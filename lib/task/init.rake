namespace :init do
  task :default do
    puts 'in top proj. dir, run the following:'
    puts '1. make -f lib/task/init.mk'
    puts '2. rake init:env'
  end

  desc "install dependencies for your env"
  task :configure do
    sh "aws configure"
  end
  
  desc "boostrap env"
  task :env do
    Rake::Task['java:install'].invoke
    Rake::Task['init:pkgs'].invoke
  end

  task :pkgs do
    %w{awscli}.each do |p|
      sh "sudo apt-get install -y awscli"
    end
  end
end

task :init do
  Rake::Task['init:default'].invoke
end
