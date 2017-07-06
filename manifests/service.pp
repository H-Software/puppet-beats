# Beats service class
class beats::service() {
  if $beats::packetbeat { include ::beats::packetbeat::service }
  if $beats::filebeat { include ::beats::filebeat::service }
  if $beats::metricbeat { include ::beats::metricbeat::service }
}
