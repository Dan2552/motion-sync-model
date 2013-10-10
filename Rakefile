require "bundler/gem_tasks"
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'motion-support'

Motion::Project::App.setup do |app|
  app.name = 'MotionSyncDemo'
  app.files += Dir.glob(File.join(app.project_dir, 'lib/motion-sync-model/**/*.rb'))
end

desc "Build the gem"
task :gem do
  sh "bundle exec gem build motion-sync-model.gemspec"
  sh "mkdir -p pkg"
  sh "mv *.gem pkg/"
end
