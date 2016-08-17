class tdp_app (
    $app_version = '1.0',
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
    before => File['/etc/tdp-recruitment/app_config.yml'],
  }
  file {'/etc/tdp-recruitment/app_config.yml':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/app_config.yml.erb"),
    require => Package['tdp-recruitment'],
    notify  => Service['tdp-recruitment'],
  }
  file {'/etc/systemd/system/tdp-recruitment.service':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/tdp-recruitment.service.erb"),
    require => Package['tdp-recruitment'],
  }
  service { 'tdp-recruitment':
    ensure  => running,
    enable  => true,
    require => File['/etc/systemd/system/tdp-recruitment.service'],
  }
}
