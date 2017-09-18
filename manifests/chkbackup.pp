# Define: burp::chkbackup
# Parameters:
# arguments
#

define burp::chkbackup (
    $chkwarninghours   = 24,
    $chkcriticalhours  = 48,
    $chkbackupclient   = $title
  ) {

# create check script from template
  file { "/usr/local/sbin/chkclient_${title}.sh":
    mode    => '0755',
    content => template('burp/chkbackup.erb'),
  }

# export check so sensu monitoring can make use of it
  @sensu::check { "Check Backup ${title}" :
    command => "/usr/bin/sudo /usr/local/sbin/chkclient_${title}.sh",
    tag     => 'central_sensu',
  }

# add entry to sudoers
  file_line { "sudo_rule_${title}":
    path => '/etc/sudoers',
    line => "sensu ALL = (root) NOPASSWD: /usr/local/sbin/chkclient_${title}.sh",
  }

}


