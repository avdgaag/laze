require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "laze"
    gem.summary     = %Q{A simple static site manager}
    gem.description = <<-EOF
      Laze is a simple static website generator, inspired by the likes of
      jekyll, bonsai, nanoc, webby and many others. It's main purpose is to
      convert a bunch of text files into a working website.
    EOF
    gem.email       = "info@agwebdesign.nl"
    gem.homepage    = "http://github.com/avdgaag/laze"
    gem.authors     = ["Arjan van der Gaag"]
    gem.add_development_dependency("thoughtbot-shoulda")
    gem.add_dependency('liquid')
    gem.add_dependency('rdiscount')
    gem.add_dependency('RedCloth')
    gem.add_dependency('jsmin')
    gem.add_dependency('cssmin')
    gem.add_dependency('directory_watcher')
    gem.add_dependency('less')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "laze #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "--format progress"
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end