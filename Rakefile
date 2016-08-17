task :build_rpms => [:build_rpm_tdp]

task :build_rpm_tdp do
  FileUtils.rm_r Dir.glob('target/*'), :force => true
  FileUtils.mkdir_p 'target/etc/puppetlabs/code/environments/production'
  FileUtils.cp_r 'puppet/modules', 'target/etc/puppetlabs/code'
  FileUtils.cp_r 'puppet/environments/production/modules', 'target/etc/puppetlabs/code/environments/production'
  FileUtils.cp_r 'puppet/environments/production/manifests', 'target/etc/puppetlabs/code/environments/production'
  system ("fpm -s dir -t rpm -a all -n tdp-puppet -C target -v ${BUILD_NUMBER} -p tdp-puppet-${BUILD_NUMBER}.x86_64.TYPE")
end
