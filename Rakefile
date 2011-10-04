require "bundler"
require "bundler/setup"

Bundler.setup

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |features|
  features.cucumber_opts = "features --tags ~@wip --format progress"
end
namespace :features do
  Cucumber::Rake::Task.new(:pretty, "Run Cucumber features with output in pretty format") do |features|
    features.cucumber_opts = "features --tags ~@wip --format pretty"
  end
  Cucumber::Rake::Task.new(:wip, "Run @wip (Work In Progress) Cucumber features") do |features|
    features.cucumber_opts = "features --tags @wip --format progress"
  end
end

require 'rspec/core/rake_task'
desc "Run specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w(--color --format p)
end
namespace :spec do
  desc "Run specs with output in documentation format"
  RSpec::Core::RakeTask.new(:doc) do |t|
    t.rspec_opts = ["--color", "--format d"]
  end
end

desc "Start Autotest CI"
task :autotest => [".autotest", ".rspec"] do
  system "bundle exec autotest"
end
namespace :autotest do
  desc "autotest + features"
  task :features do
    system "(export AUTOFEATURE=true && bundle exec autotest)"
  end
end

file "README.html" => "README.markdown" do |t|
  system "kramdown #{t.prerequisites.first} > #{t.name}"
end

desc "Generate README.html"
task :html => "README.html" do |t|
  puts "#{t.prerequisites.first} generated"
end

desc "Clean up the generated stuff"
task :clean do
  system "git clean -fd"
end

task :default => ["spec:doc", "features:pretty"]
