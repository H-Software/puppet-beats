# Setup the official repo
class beats::repo::apt() {

  #include apt

  apt::key { 'elasticsearch':
    id          => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
    source  => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
    require     => Package['apt-transport-https'],
  }

  apt::source { 'elastic-5.x':
    location => 'https://artifacts.elastic.co/packages/5.x/apt',
    release  => 'stable',
    repos    => 'main',
    include  => {
      'deb'  => true,
    },
    require  => [
                 apt::key['elasticsearch'],
                 Package['apt-transport-https'],
                ],
  }

#  exec {'apt-get update':
#    command => 'apt-get -qq update',
#    path    => '/usr/bin',
#    unless  => ['/usr/bin/dpkg -l | /bin/grep apt-transport-https'],
#  }

  if ! defined(Package['apt-transport-https']){
    package {'apt-transport-https':
      ensure  => installed,
#    require => Exec['apt-get update'],
    }
  }
}

