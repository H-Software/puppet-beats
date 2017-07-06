# Configure metricbeat class
class beats::metricbeat::config inherits beats::metricbeat {
  if ($beats::metricbeat::ensure != 'absent'){
    beats::common::headers {'metricbeat':}
    concat::fragment {'metricbeat.header':
      target  => '/etc/metricbeat/metricbeat.yml',
      content => template('beats/metricbeat/metricbeat.yml.erb'),
      order   => '06',
    }
  }
}