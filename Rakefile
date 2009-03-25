require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rcov/rcovtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "navigare"
    s.summary = %Q{The Navigare gem plugin gives you the ability to setup the navigation system in your Rails application in a very flexible and centralized way.}
    s.email = "bacsi.laszlo@virgo.hu"
    s.homepage = "http://github.com/virgo/navigare"
    s.description = "The Navigare gem plugin gives you the ability to setup the navigation system in your Rails application in a very flexible and centralized way."
    s.authors = ["Laszlo Bacsi"]
    s.files = FileList['lib/**/*.rb', '[A-Z]*', 'test/**/*', 'rails/*'].to_a
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'navigare'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rcov::RcovTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :default => :rcov
