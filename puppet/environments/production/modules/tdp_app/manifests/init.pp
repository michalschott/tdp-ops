class tdp_app (
  $dbuser    = 'tdp',
  $dbpass    = 'tdp',
  $dbname    = 'tdprecruitment',
  $dbhost    = 'localhost',
  $port      = 8888,
  $adminport = 8889,
  $mailhost  = 'localhost',
  $mailport  = 25,
  $mailfrom  = 'no-reply@localhost',
  ) {
  package { 'java-1.8.0-openjdk':
    ensure => latest,
  }
  package { 'tdp-recruitment':
    require => Package['java-1.8.0-openjdk'],
    ensure  => latest,
  }
  file { '/etc/tdp-recruitment':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    before => File['/etc/tdp-recruitment/app_config.yml'],
  }
  file { '/etc/tdp-recruitment/app_config.yml':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/app_config.yml.erb"),
    require => Package['tdp-recruitment'],
    notify  => Service['tdp-recruitment'],
  }
  file { '/etc/systemd/system/tdp-recruitment.service':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/${module_name}/tdp-recruitment.service",
    require => Package['tdp-recruitment'],
    notify  => Exec['Refresh system daemon'],
  }
  service { 'tdp-recruitment':
    ensure  => running,
    enable  => true,
    require => File['/etc/systemd/system/tdp-recruitment.service'],
  }
  exec { 'Refresh system daemon':
    command     => '/usr/bin/systemctl daemon-reload',
    refreshonly => true,
  }
}
