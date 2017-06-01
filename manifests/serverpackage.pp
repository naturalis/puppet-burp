# Class: burp::package-burp-client
#


class burp::serverpackage{

  if $::operatingsystem == 'Ubuntu' or $::operatingsystem == 'Debian'  {

    if !defined(Class['apt']) {
      class { 'apt': }
    }

    apt::source { 'ziirish':
      location => "http://ziirish.info/repos/${operatingsystem.downcase}/${lsbdistcodename}",
      release  => 'zi-stable',
      repos    => 'main',
      key      => {
        'id'     => '3F154A9DA875B6C613214D609EBCB6DB11260BA7',
        'server' => 'keyserver.ubuntu.com'
      }
    }

    apt::key {'ziirish':
        id     => '3F154A9DA875B6C613214D609EBCB6DB11260BA7',
        server => 'keyserver.ubuntu.com'
    }

    package { 'burp-server':
      ensure   => latest,
      install_options => ['--allow-unauthenticated', '-f'],
      require  => Apt::Source['ziirish']
    }
  }
  else {
    notice('Operatingsystem not supported, perform manual burp installation.')
  }


}
