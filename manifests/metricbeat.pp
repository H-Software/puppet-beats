# metricbeat class
class beats::metricbeat (
  $ensure  = present,
  $modules = {
    'system' => { 'metricsets' => [ 'cpu', 'load', 'core'],
      'enabled'  => true,
      'period'   => '10s',
      'processes' => "['.*']",
      },
    },
  $manage_repo = $beats::manage_repo,
){

  if ($ensure == 'absent'){
    $service_ensure = undef
    $service_enable = undef
  }
  else{
    $service_ensure = $beats::ensure
    $service_enable = $beats::enable

    include ::beats::metricbeat::config
  }

  if ($manage_repo){
    $require_repo = Yumrepo['elastic-beats']
  }
  else {
    $require_repo = []
  }

  case $::osfamily {
    'RedHat': {
      package {'metricbeat':
        ensure  => $ensure,
        require => $require_repo,
      }
    }
    'Debian': {
      include ::apt
      include ::apt::update

      package {'metricbeat':
        ensure  => $ensure,
        require => Class['apt::update'],
      }
    }
    default: {
      fail("${::osfamily} not supported yet")
    }
  }

  service { 'metricbeat':
    ensure => $service_ensure,
    enable => $service_enable,
  }

  if ($ensure != 'absent'){
    Package['metricbeat'] -> Class['beats::metricbeat::config'] ~> Service['metricbeat']
  }
  else{
    Package['metricbeat'] ~> Service['metricbeat']
  }
}
