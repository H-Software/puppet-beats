# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
#include ::beats
class { '::beats':
  outputs_deep_merge => false,
  outputs_logstash   => {
    'filebeat'   => { 'hosts' => [ 'logstash.example.com:5044' ], },
    'metricbeat' => { 'hosts' => [ 'logstash.example.com:5044' ], },
  },
}

#include ::beats::metricbeat
class { '::beats::metricbeat':
}

#include ::beats::filebeat
class { '::beats::filebeat':
    prospectors => {
              'syslog' => {
                  'document_type' => 'syslog',
                  'paths'         => [ '/var/log/syslog',
                                '/var/log/auth.log',
                                '/var/log/dpkg.log',
                                '/var/log/mail.log',
                                '/var/log/ntp',
                                '/var/log/zabbix/zabbix_agentd2.log',
                              ],
              },
    },
}
