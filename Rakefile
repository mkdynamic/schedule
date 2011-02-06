require "rubygems"
require "rake/gempackagetask"
require "rake/rdoctask"
require "rake/testtask"

task :default => :test

spec = Gem::Specification.new do |s|
  s.name              = "schedule"
  s.version           = "0.0.3"
  s.summary           = "A Ruby replacement for Cron"
  s.author            = "Mark Dodwell"
  s.email             = "hi@mkdynamic.co.uk"
  s.homepage          = "http://github.com/mkdynamic/schedule"

  # Rdoc
  # s.has_rdoc          = true
  # s.extra_rdoc_files  = %w(Readme.markdown)
  # s.rdoc_options      = %w(--main Readme.markdown)

  # Files
  s.files             = %w(Rakefile README.md) + Dir.glob("{bin,lib,test}/**/*")
  s.executables       = FileList["bin/**"].map { |f| File.basename(f) }
  s.require_paths     = ["bin", "lib"]

  # Dependencies
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3")
  s.add_development_dependency("shoulda")
  s.add_development_dependency("timecop")
end

#
# Specification
#

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") { |f| f.write(spec.to_ruby) }
end

#
# Build
#

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

task :package => :gemspec # build gemspec when packaging

#
# Tests
#

Rake::TestTask.new do |t|
  t.libs = [File.expand_path("lib"), "test"]
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

#
# Documentation
#

# Rake::RDocTask.new do |rd|
#   rd.main = "README.md"
#   rd.rdoc_files.include("README.md", "lib/**/*.rb")
#   rd.rdoc_dir = "rdoc"
# end

# desc "Clear out RDoc and generated packages"
# task :clean => [:clobber_rdoc, :clobber_package] do
#   rm "#{spec.name}.gemspec"
# end

#
# Release
#

desc "Tag the repository in git with gem version number"
task :tag do
  #`git fetch --tags`
  if `git tag`.split("\n").include?("v#{spec.version}")
    raise "Version #{spec.version} has already been released."
  end
  
  changed_files = `git diff --cached --name-only`.split("\n") + `git diff --name-only`.split("\n")
  if changed_files == ["Rakefile"]
    # MAGIC! automatically update Schedule::VERSION constant
    file = "lib/#{spec.name}.rb"
    s = File.read(file)
    File.open(file, "w") do |f|
      f.write(s.gsub(/^(\s*)VERSION(\s*)=(\s*)(["'])[\d\.]+(['"])(\s*)$/, %{\\1VERSION\\2=\\3\\4#{spec.version.to_s}\\5\\6}))
    end
    if File.read(file).match(/^\s*VERSION\s*=\s*"([\d\.]+)"\s*$/)[1] != spec.version.to_s
      "VERSION constant in #{file} differs from gemspec version."
    end
    
    Rake::Task["package"].invoke
    
    `git add #{File.expand_path("../#{spec.name}.gemspec", __FILE__)} Rakefile lib/schedule.rb`
    `git commit -m "prepare version #{spec.version}"`
    `git tag v#{spec.version}`
    #`git push --tags`
    #`git push`
  else
    raise "Repository contains uncommitted changes; either commit or stash."
  end
end

# desc "Tag and publish the gem to rubygems.org"
# task :publish => :tag do
#   `gem push pkg/#{spec.name}-#{spec.version}.gem`
# end
