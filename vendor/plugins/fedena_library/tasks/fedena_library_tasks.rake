namespace :fedena_library do
  desc "Install Fedena Library Module"
  task :install do
    system "rsync -ruv --exclude=.svn vendor/plugins/fedena_library/public ."
  end
end
