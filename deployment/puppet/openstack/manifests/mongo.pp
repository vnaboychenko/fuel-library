# == Class: openstack::mongo

class openstack::mongo (
  $ceilometer_database          = "ceilometer_database",
  $ceilometer_user              = "ceilometer_user",
  $ceilometer_metering_secret   = undef,
  $ceilometer_db_password       = $ceilometer_hash[db_password],
  $ceilometer_metering_secret   = "ceilometer",
  $mongodb_port                 = 27017,
  $mongodb_bind_address         = ['0.0.0.0'],
) {

#  notify {"MongoDB params: $ceilometer_user $ceilometer_database $ceilometer_db_password": }


  class {'::mongodb::client':
  } ->

  class {'::mongodb::server':
    port    => $mongodb_port,
    verbose => true,
    bind_ip => $mongodb_bind_address,
    auth => true,
  } ->

  mongodb::db { $ceilometer_database:
    user          => $ceilometer_user,
    password      => $ceilometer_db_password,
    roles         => ['readWrite', 'dbAdmin', 'dbOwner'],
  } ->

  mongodb::db { 'admin':
    user         => 'admin',
    password     => $ceilometer_db_password,
    roles        => ['userAdmin','readWrite', 'dbAdmin', 'dbAdminAnyDatabase', 'readAnyDatabase', 'readWriteAnyDatabase', 'userAdminAnyDatabase', 'clusterAdmin', 'clusterManager', 'clusterMonitor', 'hostManager', 'root' ],
  } 

 #notify {"mongo: $ceilometer_db_password": }

}
# vim: set ts=2 sw=2 et :
