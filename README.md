# AppHealth
[ Build status ]

AppHealth checks the response for a specific URL on each app server. It does so by overwriting the Host header to the original hostname to trick
the app server in serving the correct content. It also speeds up the check by creating a seperate thread for each request and outputs to stdout.

## Usage
AppHealth checks for a `.apphealth.yml` in either the directory your in or in your home directory. Create this file on a per project basis or just put it in your home dir as a default.

The structure of the confg file needs to be as followed:

```yaml
default_url: http://domain.com/foo123
servers:
  - server01.domain.com
  - server02.domain.com
```

* `default_url` will be checked when no parameters are supplied to the command
* `servers` is an array of servers that are requested. It can be of any size.

After creating your config file you can check the app server by running the following command:

``apphealth [url]`

* `url` is an optional url to check, if none is given it will check the `default_url` from the config.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
AppHealth is released under the [MIT License](LICENSE).
