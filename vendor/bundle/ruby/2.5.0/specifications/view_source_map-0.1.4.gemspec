# -*- encoding: utf-8 -*-
# stub: view_source_map 0.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "view_source_map".freeze
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ryo Nakamura".freeze]
  s.date = "2017-03-06"
  s.description = "This is a Rails plugin to insert the path name of a rendered partial view as HTML comment in development environment".freeze
  s.email = ["r7kamura@gmail.com".freeze]
  s.homepage = "https://github.com/r7kamura/view_source_map".freeze
  s.rubygems_version = "2.7.6".freeze
  s.summary = "Rails plugin to view source map".freeze

  s.installed_by_version = "2.7.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, [">= 3.2"])
      s.add_development_dependency(%q<rspec-rails>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rails>.freeze, [">= 3.2"])
      s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>.freeze, [">= 3.2"])
    s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
  end
end
