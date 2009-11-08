spec = Gem::Specification.new { |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  
  s.name = "quantity"
  s.version = "0.9.4"

  s.summary = "Small framework to simplify quantity math."

  s.author = "Alexander A. Portnov"
  s.email = "alex.portnov@gmail.com"
  
  s.homepage = "http://rubyforge.org/projects/quantitymanager/"
  s.rubyforge_project = "quantitymanager"
  
  s.platform = Gem::Platform::RUBY
  
  # = MANIFEST =
  s.files = %w[
    LICENSE
    README.rdoc
    Rakefile
    lib/config/default.rb
    lib/quantity.rb
    lib/quantity/base.rb
    lib/quantity/calculator.rb
    lib/quantity/configuration.rb
    lib/quantity/extensions.rb
    lib/quantity/unit/base.rb
    lib/quantity/unit/composition.rb
    quantity.gemspec
    test/calculator_test.rb
    test/composed_unit_test.rb
    test/configuration_test.rb
    test/custom_conversion_test.rb
    test/extensions_test.rb
    test/quantifiable_test.rb
    test/quantity_test.rb
    test/simple_unit_test.rb
    test/test_helper.rb
    test/unit_optimizer_test.rb
    test/unit_spec_parser_test.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select {|path| path =~ /^test\/.*_test.rb/}
  
  s.rubygems_version = '1.1.1'
}
