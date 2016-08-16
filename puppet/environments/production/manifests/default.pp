node "vm-rec-prod-app.kainos.com" {
}

node "tdp-jenkins.kainos.com" {
  include epel, yum_repo

  $dependencies = [ 'git', 'rubygems', 'gcc', 'ruby-devel', 'rpm-build']
  $dependencies.each |$dependency| {
    package {$dependency:
      ensure => latest,
    }
  }

  package {'bundler':
    ensure   => installed,
    provider => 'gem',
    require  => Package['rubygems'],
  }

  package {'ansible':
    ensure  => installed,
    require => Class['epel']
  }

  class { 'nginx': }

  nginx::resource::upstream {'jenkins':
    members => ['127.0.0.1:8080'],
  }

  nginx::resource::vhost {'172.16.253.52':
    proxy => '127.0.0.1:8080',
    use_default_location => false,
  }

  nginx::resource::location{'local':
    location  => '/yum',
    vhost     => 'yum.mgmt.woa4pl',
    www_root  => '/var/www/yum',
    autoindex => 'on',
  }
}


