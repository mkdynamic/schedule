# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{schedule}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mark Dodwell"]
  s.date = %q{2011-02-05}
  s.default_executable = %q{cr}
  s.email = %q{hi@mkdynamic.co.uk}
  s.executables = ["cr"]
  s.files = ["Rakefile", "README.md", "bin/cr", "lib/schedule/logger.rb", "lib/schedule/notifier/base.rb", "lib/schedule/notifier/console.rb", "lib/schedule/notifier/email.rb", "lib/schedule/notifier.rb", "lib/schedule/runner.rb", "lib/schedule/task.rb", "lib/schedule.rb", "test/commands/flushing", "test/commands/raises_exception", "test/commands/success", "test/integration/binary_test.rb", "test/test_helper.rb", "test/unit/logger_test.rb", "test/unit/runner_test.rb", "test/unit/task_test.rb"]
  s.homepage = %q{http://github.com/mkdynamic/schedule}
  s.require_paths = ["bin", "lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A Ruby replacement for Cron}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<timecop>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<timecop>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<timecop>, [">= 0"])
  end
end
