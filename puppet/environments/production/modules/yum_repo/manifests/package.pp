class yum_repo::package {
  package {['createrepo', 'yum-utils']:
    ensure => latest,
  }
}
