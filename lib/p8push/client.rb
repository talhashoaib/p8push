require 'openssl'
require 'jwt'
require 'net-http2'

module P8push

  APPLE_PRODUCTION_JWT_URI = 'https://api.push.apple.com'
  APPLE_DEVELOPMENT_JWT_URI = 'https://api.sandbox.push.apple.com'

  class Client
    attr_accessor :jwt_uri
    class << self
      def development(private_key: nil, team_id: nil, key_id: nil, timeout: nil)
        client = self.new(private_key: private_key, team_id: team_id, key_id: key_id, timeout: timeout)
        client.jwt_uri = APPLE_DEVELOPMENT_JWT_URI
        client
      end

      def production(private_key: nil, team_id: nil, key_id: nil, timeout: nil)
        client = self.new(private_key: private_key, team_id: team_id, key_id: key_id, timeout: timeout)
        client.jwt_uri = APPLE_PRODUCTION_JWT_URI
        client
      end
    end

    def initialize(private_key: nil, team_id: nil, key_id: nil, timeout: nil)
      @private_key = private_key || File.read(ENV['APN_PRIVATE_KEY'])
      @team_id = team_id || ENV['APN_TEAM_ID']
      @key_id = key_id || ENV['APN_KEY_ID']
      @timeout = Float(timeout || ENV['APN_TIMEOUT'] || 2.0) rescue 2.0
    end

    def jwt_http2_post(topic, payload, token)
      ec_key = OpenSSL::PKey::EC.new(@private_key)
      jwt_token = JWT.encode({iss: @team_id, iat: Time.now.to_i}, ec_key, 'ES256', {kid: @key_id})
      client = NetHttp2::Client.new(@jwt_uri)
      h = {}
      h['apns-expiration'] = '0'
      h['apns-priority'] = '10'
      h['apns-topic'] = topic
      h['scheme'] = 'https'
      h['authorization'] = "bearer #{jwt_token}"
      h['content-type'] = 'application/json'

      res = client.call(:post, '/3/device/'+token, body: payload.to_json, timeout: @timeout,
                        headers: h)
      client.close
      return nil if res.status.to_i == 200
      res.body
    end

    def push(*notifications)
      return if notifications.empty?

      notifications.flatten!

      notifications.each_with_index do |notification, index|
        next unless notification.kind_of?(Notification)
        next if notification.sent?
        next unless notification.valid?

        notification.id = index

        err = jwt_http2_post(notification.topic, notification.payload, notification.token)
        if err == nil
          notification.mark_as_sent!
        else
          puts err
          notification.apns_error_code = err
          notification.mark_as_unsent!
        end
      end
    end
  end
end
