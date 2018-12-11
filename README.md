# beats
Elastic beats puppet module
=======
License
-------
GPL v2

## WARNING ##

* This module is under development. Most things work most of the time, mostly.
Some protocols and settings are still missing.

* From module version 0.10.0 are unsupported beats < v5.x

## COMPATIBILITY ##

* Filebeats & Metricbeat tested on:

  * CentOS 6 with puppet 3.8.7, 4.10.x

  * CentOS 7 with puppet 4.10

  * Debian 9.x with puppet 4.10

  * Ubuntu 16.04 with puppet 4.10

* Minimally tested on Debian 7-9, Ubuntu 16.04 and puppet 3.8.7

  * Debian 7 needs enable contrib repo (or disable manage_geoip)

  * all Debians needs packages: gnupg, lsb-release

## Example Use ##
```
class { 'beats':
    outputs_deep_merge => false,
    outputs_logstash => {
      "filebeat" => { "hosts" => [ "logstash.example.com:5044" ],
                                   "use_tls" => true,
                    },
    },
    version_v5 => true,
    agentname   => 'server-name',
}

class { 'beats::filebeat':
    prospectors => {
              'syslog' => {
                  'document_type' => "syslog",
                  'paths'  => [ "/var/log/messages",
                                "/var/log/secure",
                                "/var/log/yum.log",
                                "/var/log/cron",
                                "/var/log/maillog",
                                "/var/log/ntp",
                              ],
              },
              'nginx-error'  => {
                  'document_type' => "nginx-error",
                  'paths'  => [
                                  "/var/log/nginx/*.error.log",
                                 "/var/log/nginx/error.log",
                              ],
              },
              'nginx-access'  => {
                  'document_type' => "nginx-access",
                  'paths'  => [
                                 "/var/log/nginx/*.access.log",
                                 "/var/log/nginx/access.log",
                              ],
              },
    },
}
```

```
class {'beats::metricbeat':
  modules  => {
                 'system' => { 'metricsets' => [ 'cpu', 'load', 'core', 'diskio', 'filesystem', 'memory', 'process'],
                                   'enabled'  => true,
                                   'period'   => '10s',
                                   'processes' => "['.*']",
                 },
                 'nginx' => { 'metricsets' => ["nginx_stat"],
                                   'enabled'  => true,
                                   'period'   => '10s',
                                   'hosts'    => ["https://127.0.0.1"],
                 },
              },
}
```
## Example Use with hiera ##

```
include ::beats
include ::beats::metricbeat
include ::beats::filebeat
```


### Hiera ###
```
"beats::filebeat::prospectors": {
  "syslog": {
    "fields": {
      "type": "syslog"
    },
    "paths": [
      "/var/log/syslog"
    ]
  }
},
"beats::outputs_deep_merge": true,
"beats::outputs_logstash": {
  "filebeat": {
    "hosts": [
      "localhost:5044"
    ]
  },
  "metricbeat": {
    "hosts": [
      "localhost:5044"
    ]
  }
}
```

The ES output *should* work, but I've not tested it yet.
Some digging around inside the module will be necessary to make bits work.
