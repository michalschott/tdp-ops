require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths     = ["vendor/**/*.pp", "modules/**/*.pp"]
  config.disable_checks   = ['documentation', 'class_inherits_from_params_class', '140chars']
  config.fail_on_warnings = true
  config.with_context     = true
  config.log_format       = '%{path}:%{linenumber}:%{KIND}: %{message}'
end

RSpec::Core::RakeTask.new(:rspec) do |config|
  config.pattern = 'modules/*/spec/*/*_spec.rb'
end

task :default => [:syntax, :lint, :rspec]

task :build_rpms => [:build_rpm_tdp]

task :build_rpm_tdp do
  FileUtils.rm_r Dir.glob('target/*'), :force => true
  FileUtils.mkdir_p 'target/etc/puppetlabs/code/environments/tdp/modules'
  FileUtils.mkdir_p 'target/etc/puppetlabs/code/environments/tdp/manifests'
  FileUtils.cp_r 'modules', 'target/etc/puppetlabs/code/environments/tdp'
  FileUtils.cp_r 'environments', 'target/etc/puppetlabs/code/environments/tdp/modules'
  system ("fpm -s dir -t rpm -a all -n tdp-puppet -C target -v ${BUILD_NUMBER} -p tdp-puppet-${BUILD_NUMBER}.x86_64.TYPE")
end

PuppetSyntax.exclude_paths = ["vendor/**/*", "modules/**/*"]
