# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{navigare}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Laszlo Bacsi"]
  s.date = %q{2009-03-25}
  s.description = %q{The Navigare gem plugin gives you the ability to setup the navigation system in your Rails application in a very flexible and centralized way.}
  s.email = %q{bacsi.laszlo@virgo.hu}
  s.files = ["lib/navigare/helpers.rb", "lib/navigare/link.rb", "lib/navigare/navigation.rb", "lib/navigare/tab.rb", "lib/navigare.rb", "LICENSE", "Rakefile", "README", "VERSION.yml", "test/navigare_test.rb", "test/test_helper.rb", "rails/init.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/virgo/navigare}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{The Navigare gem plugin gives you the ability to setup the navigation system in your Rails application in a very flexible and centralized way.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
