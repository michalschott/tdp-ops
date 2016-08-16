node "vm-rec-prod-app.kainos.com" {
}

node "tdp-jenkins.kainos.com" {
  include epel
  include nginx

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

  class {'yum_repo':
    require => Class['nginx'],
  }

  nginx::resource::upstream {'jenkins':
    members => ['127.0.0.1:8080'],
  }

  nginx::resource::vhost {'172.16.253.52':
    use_default_location => false,
  }

  nginx::resource::location {'jenkins':
    location              => '/',
    vhost                 => '172.16.253.52',
    proxy                 => 'http://jenkins',
    proxy_connect_timeout => '10s',
    proxy_read_timeout    => '10s',
    proxy_set_header      => ['Host $host:$server_port', 'X-Real-IP $remote_addr', 'X-Forwarded-For $proxy_add_x_forwarded_for', 'X-Forwarded-Proto $scheme'],
  }

  nginx::resource::location {'local':
    location  => '/yum',
    vhost     => '172.16.253.52',
    www_root  => '/var/www/',
    autoindex => 'on',
  }

  if ($::selinux) {
    selboolean {'httpd_can_network_connect':
      persistent => true,
      value      => 'on',
    }
  }
}
