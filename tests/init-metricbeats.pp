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
#    'filebeat' => { 'hosts' => [ 'logstash.example.com:5044' ], },
    'metricbeat'  => { 'hosts' => [ 'logstash.example.com:5044' ], },
  },
}

#include ::beats::topbeat
class { '::beats::metricbeat':
  modules  => {
                'system' => { 'metricsets' => [ 'cpu', 'load', 'core', 'diskio', 'filesystem', 'memory', 'process'],
                              'enabled'    => true,
                              'period'     => '10s',
                              'processes'  => "['.*']",
                },
                'nginx' => { 'metricsets' => ['nginx_stat'],
                             'enabled'    => true,
                             'period'     => '10s',
                             'hosts'      => ['https://127.0.0.1'],
                },
              },
}
