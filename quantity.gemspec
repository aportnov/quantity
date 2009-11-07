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
    Rakefile
    lib/config/default_configuration.rb
    lib/quantity.rb
    lib/unitmanager/calculator.rb
    lib/unitmanager/configuration.rb
    lib/unitmanager/quantity.rb
    lib/unitmanager/simple_unit.rb
    lib/unitmanager/unit_composition.rb
    lib/unitmanager/utils.rb
    stories/calculator.txt
    stories/configuration.txt
    stories/project-plan.txt
    stories/quantity.txt
    test/all_tests.rb
    test/calculator_test.rb
    test/composed_unit_test.rb
    test/configuration_test.rb
    test/custom_conversion_test.rb
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
