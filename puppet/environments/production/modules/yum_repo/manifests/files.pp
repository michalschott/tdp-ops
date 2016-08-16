class yum_repo::files (){
  $dirs_to_create  = ['/var/www',
                      '/var/www/yum',
                      '/var/www/yum/local',
                      '/var/www/yum/local/x86_64',
                      '/var/www/yum/local/x86_64/RPMS',
                      ]

  file { $dirs_to_create:
    ensure => 'directory',
    owner  => 'nginx',
    group  => 'nginx',
    mode   => '2775',
  }

  exec {'init_createrepo_local':
    umask   => '2002',
    command => '/usr/bin/createrepo /var/www/yum/local',
    creates => '/var/www/yum/local/repodata',
    require => [Package['createrepo'],
                File['/var/www/yum/local']
                ],
  }
}
