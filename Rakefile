require 'rake'
require 'rspec/core/rake_task'

task :build_rpms => [:build_rpm_tdp]

task :build_rpm_tdp do
  FileUtils.rm_r Dir.glob('target/*'), :force => true
  FileUtils.mkdir_p 'target/etc/puppetlabs/code/environments/production/modules'
  FileUtils.mkdir_p 'target/etc/puppetlabs/code/environments/production/manifests'
  FileUtils.cp_r 'modules', 'target/etc/puppetlabs/code/environments/production'
  FileUtils.cp_r 'environments/production/manifests', 'target/etc/puppetlabs/code/environments/production/'
  system ("fpm -s dir -t rpm -a all -n tdp-puppet -C target -v ${BUILD_NUMBER} -p tdp-puppet-${BUILD_NUMBER}.x86_64.TYPE")
end
