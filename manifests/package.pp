# Install beats packages
class beats::package (
  $version = $beats::version,
){
  case $::osfamily {
    'Debian': {
      # Install pcap because it's useful and used in packetbeat
      package { 'libpcap0.8':
        ensure => installed,
      }

      case $::operatingsystem {
        'Ubuntu': {
          $geoip_package_name='geoip-database'
        }
        default: {
          $geoip_package_name='geoip-database-contrib'
        }
      }

      if $beats::manage_geoip {
        package { $geoip_package_name:
          ensure => latest,
        }
      }
    }
    'RedHat': {
      package { 'libpcap':
        ensure => installed,
      }

      if $beats::manage_geoip {

        if defined(Class['epel']) {
          $require_for_geoip = [ Class['epel'], ]
        }
        elsif defined(Package['epel-release']) {
          $require_for_geoip = [ Package['epel-release'], ]
        }
        else {
          package { 'epel-release':
            ensure => installed,
          }
          $require_for_geoip = [ Package['epel-release'], ]
        }

        package { 'GeoIP':
          ensure  => latest,
          require => $require_for_geoip,
        }

        if ($::operatingsystemmajrelease in ['7']) {
          package { ['GeoIP-data', 'GeoIP-update']:
            ensure  => latest,
            require => $require_for_geoip,
          }
        }

      }

    }
    default: { fail("${::osfamily} not supported yet") }
  }
}
