# burp client config files

define burp::clientconfig (
    $clientname        = $name,
    $includes          = undef,
    $excludes          = undef,
    $options           = undef,
    $password          = undef,
)
{

  file { '/etc/burp/clientconfig':
    ensure     => 'directory',
    require    => Package['burp']
  }

  file { "/etc/burp/clientconfig/${clientname}":
    ensure     => present,
    mode       => '600',
    content    => template("burp/clientconfig.erb"),
    require    => File['/etc/burp/clientconfig']
  }

}