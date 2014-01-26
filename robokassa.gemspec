# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "robokassa"
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Victor Zagorski aka shaggyone"]
  s.date = "2014-01-20"
  s.description = "\n    Robokassa is payment system, that provides a single simple interface for payment systems popular in Russia.\n    If you have customers in Russia you can use the gem.\n\n    The first thing about this gem, is that it was oribinally designed for spree commerce. So keep it in mind.\n  "
  s.email = ["victor@zagorski.ru"]
  s.files = [".gitignore", "Gemfile", "README.md", "Rakefile", "VERSION", "app/controllers/robokassa_controller.rb", "config/locales/en.yml", "config/locales/ru.yml", "config/routes.rb", "lib/robokassa.rb", "lib/robokassa/controller.rb", "lib/robokassa/interface.rb", "robokassa.gemspec", "spec/lib/interface_spec.rb", "spec/routing/routes_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "http://github.com/shaggyone/robokassa"
  s.require_paths = ["lib"]
  s.rubyforge_project = "robokassa"
  s.rubygems_version = "1.8.24"
  s.summary = "This gem adds robokassa support to your app."
  s.test_files = ["spec/lib/interface_spec.rb", "spec/routing/routes_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.2.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 2.5.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<thor>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<combustion>, ["~> 0.3.1"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 3.2.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, [">= 2.5.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<thor>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<combustion>, ["~> 0.3.1"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.2.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, [">= 2.5.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<thor>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<combustion>, ["~> 0.3.1"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
