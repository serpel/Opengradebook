namespace :fedena_assignment do
  desc "Install Fedena Assignment Module"
  task :install do
    system "rsync --exclude=.svn -ruv vendor/plugins/fedena_assignment/public ."
  end
end
