# Class: burp::server
#
#
class burp::server (
  $common_clientconfig  = undef,
  $clientconf_hash      = undef,
  $password             = $burp::client_password,
) {

  # file { '/etc/burp/clientconfdir':
  #   ensure     => 'directory',
  #   require    => Package['burp-server']
  # }

  file { '/etc/burp/burp-server.conf':
    ensure  => present,
    mode    => '0644',
    content => template('burp/burp-server.conf.erb'),
    require => Package['burp-server']
  }

  file { '/etc/burp/burp.conf':
    ensure  => present,
    mode    => '0644',
    content => template('burp/burp.conf.erb'),
    require => Package['burp-server']
  }

  file { '/etc/default/burp':
    ensure  => present,
    mode    => '0600',
    content => template('burp/default.erb'),
    require => Package['burp-server']
  }

  file { '/etc/burp/clientconfdir/incexc/common':
    ensure  => present,
    mode    => '0600',
    content => template('burp/common.erb'),
    require => File['/etc/burp/clientconfdir']
  }

  service { 'burp-server':
    ensure  => 'running',
    require => File['/etc/burp/burp-server.conf']
  }

  # Backup stats to logstash
  if $burp::backup_stats_logstash == true {
    file { '/etc/burp/notify_script':
      content => template('burp/notify_script.erb'),
      mode    => '0700',
      require => Package['burp-server']
    }
    file { '/etc/logrotate.d/backup_stats':
      content => template('burp/backup_stats_logrotate.erb'),
      mode    => '0644',
      require => Package['burp-server']
    }
  }

  file { "/etc/burp/clientconfdir/${::fqdn}":
    mode    => '0600',
    content => template('burp/clientconf.erb'),
    require => File['/etc/burp/clientconfdir'],
  }

  if $burp::clientconf == true {
    create_resources('burp::clientconf', $burp::server::clientconf_hash)
  }

}
