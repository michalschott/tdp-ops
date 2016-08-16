node "vm-rec-prod-app.kainos.com" {
}

node "tdp-jenkins.kainos.com" {
  include epel

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
}
