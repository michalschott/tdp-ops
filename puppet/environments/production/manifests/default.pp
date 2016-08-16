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
  nginx::resource::vhost { '172.16.253.52':
    www_root => '/var/www/yum/local',
  }
}


