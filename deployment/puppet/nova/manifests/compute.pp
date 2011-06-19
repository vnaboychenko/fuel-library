# this class should probably never be declared except
# from the virtualization implementation of the compute node
class nova::compute(
  $api_server,
  $enabled = false,
  $api_port = 8773,
  $aws_address = '169.254.169.254',
  $libvirt_type = 'kvm'
) {

  Nova_config<| |>~>Service['nova-compute']

  nova_config { 'libvirt_type': value => $libvirt_type }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  package { "nova-compute":
    ensure => present,
    require => Class['nova'],
  }

  service { "nova-compute":
    ensure => $service_ensure,
    enable => $enabled,
    require => Package["nova-compute"],
  }

  # forward guest metadata requests to correct API server
  exec { "forward_api_requests":
    command => "/sbin/iptables -t nat -A PREROUTING -d ${aws_address}/32 -p tcp -m tcp --dport 80 -j DNAT --to-destination ${api_server}:${api_port}",
    unless => "/sbin/iptables -L PREROUTING -t nat -n | egrep 'DNAT[ ]+tcp+[ ]+--[ ]+0.0.0.0\\/0+[ ]+${aws_address}+[ ]+tcp+[ ]+dpt:80+[ ]+to:${api_server}:${api_port}'"
  }

}
