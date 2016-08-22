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
  file { "/usr/local/sbin/chkclient_${title}":
    mode    => '0700',
    content => template('burp/chkbackup.erb'),
  }

# export check so sensu monitoring can make use of it
  @sensu::check { "Check Backup ${title}" :
    command => "/usr/local/sbin/chkclient_${title}.sh",
    tag     => 'central_sensu',
}

}


