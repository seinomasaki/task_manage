# -*- encoding: utf-8 -*-
# stub: activerecord-cause 0.6.0 ruby lib

Gem::Specification.new do |s|
  s.name = "activerecord-cause".freeze
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["joker1007".freeze]
  s.bindir = "exe".freeze
  s.date = "2018-03-20"
  s.description = "This gem logs where ActiveRecord actually loads record".freeze
  s.email = ["kakyoin.hierophant@gmail.com".freeze]
  s.homepage = "https://github.com/joker1007/activerecord-cause".freeze
  s.rubygems_version = "2.7.6".freeze
  s.summary = "This gem logs where ActiveRecord actually loads record".freeze

  s.installed_by_version = "2.7.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>.freeze, [">= 4"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 1.6"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
    else
      s.add_dependency(%q<activerecord>.freeze, [">= 4"])
      s.add_dependency(%q<bundler>.freeze, [">= 1.6"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 4"])
    s.add_dependency(%q<bundler>.freeze, [">= 1.6"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
  end
end
