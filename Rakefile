# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "struct_packing"
  gem.homepage = "http://github.com/TOKITAHiroshi/struct_packing"
  gem.license = "MIT"
  gem.summary = %Q{* Read/Write ruby object to byte array with C-like struct declarations.}
  gem.description = %Q{* Read/Write ruby object to byte array with C-like struct declarations.}
  gem.email = ["tokita.hiroshi@gmail.com"]
  gem.authors = ["TOKITA Hiroshi"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
=begin
require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end
=end
task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "struct_packing #{version}"
  rdoc.main = "README.rdoc"
  rdoc.rdoc_files.include('*.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
