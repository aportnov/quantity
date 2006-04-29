require 'rubygems'

Gem::manage_gems

require 'rake/gempackagetask'

spec = Gem::Specification.new { |s|
  
  s.name = "quantitymanager"
  s.version = "0.3.0"
  s.author = "Alexander A. Portnov"
  s.email = "alex.portnov@gmail.com"
  s.homepage = "http://rubyforge.org/projects/quantitymanager/"
  s.rubyforge_project = "quantitymanager"
  s.platform = Gem::Platform::RUBY
  s.summary = "Unit of measure, quantity framework"
  s.files = FileList["{lib,test,doc}/**/*"].exclude("rdoc").to_a
  s.require_path = "lib"
  s.autorequire = "quantity"
  s.test_file = "test/all_tests.rb"
}

Rake::GemPackageTask.new(spec) { |pkg|

  pkg.need_tar = true
  
}