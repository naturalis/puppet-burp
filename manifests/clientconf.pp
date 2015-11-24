# Define: burp::clientconf
# Parameters:
# arguments
#

define burp::clientconf (
  $includes = undef,
  $excludes = undef,
  $options  = undef,
  $password = undef,
  ) {

  file { "/etc/burp/clientconfdir/${title}":
    mode    => '0600',
    content => template('burp/clientconf.erb'),
    require => File['/etc/burp/clientconfdir'],
  }

}


