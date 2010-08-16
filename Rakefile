require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the dojo_on_rails plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

desc 'Generate rdoc'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Simple Rest'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

PKG_FILES = FileList[ '[a-zA-Z]*', 'lib/**/*', 'test/**/*' ]
require 'lib/simple_rest.rb'
spec = Gem::Specification.new do |s|
  s.name = "simple_rest"
  s.version = SimpleRest::VERSION
  s.author = "niquola,smecsia"
  s.email = "niquola@gmail.com,smecsia@gmail.com"
  #s.homepage = ""
  s.platform = Gem::Platform::RUBY
  s.summary = "ActionControllers helpers for restful rails"
  s.add_dependency('rails', '>= 2.3.5')
  s.files = PKG_FILES.to_a 
  s.require_path = "lib"
  s.has_rdoc = false
  s.extra_rdoc_files = ["README.rdoc"]
end

desc 'Turn this plugin into a gem.'
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
