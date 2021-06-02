# p8push
ruby gem for apple push notifications using only the new p8 format not the older pem format

add to Gemfile: `gem 'ts_p8push'`

```
[OPTIONAL]
export APN_PRIVATE_KEY=/path/APNsAuthKey_ABCDE12345.p8
export APN_TEAM_ID=XYZDE99911
export APN_KEY_ID=ABCDE12345
export APN_BUNDLE_ID=com.bundle.id
```

```
Environment can be intiated either via exports and use below
APN = P8push::Client.development

OR
Environment can be intiated by providing the configs on the go
APN = P8push::Client.development(private_key: 'YOUR_PRIVATE_KEY_P8_CONTENTS', team_id: 'YOUR_TEAM_ID', key_id: 'YOUR_KEY_ID', timeout: 2.0)

token = 'GETREALTOKENFROMADEVICE'
notification = P8push::Notification.new(device: token)
notification.alert = 'Hello, World!'
notification.topic = 'com.some.other.id' # if you do not want default ENV['APN_BUNDLE_ID'] one
APN.push(notification)
```

The gem with pem format this came from is https://github.com/nomad/houston
