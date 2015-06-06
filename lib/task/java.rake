namespace :java do
  JAVA_VERSION = '8'

  desc "add java repo to apt-get repository"
  task :repo do
    sh "sudo add-apt-repository -y ppa:webupd8team/java"
  end

  desc "apt-get update"
  task :update do
    sh "sudo apt-get update -y"
  end

  desc "install Java 8"
  task :install do
    sh "echo oracle-java#{JAVA_VERSION}-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections"
    sh "sudo apt-get install oracle-java#{JAVA_VERSION}-installer"
  end
  
  desc "install Java #{JAVA_VERSION} and make it the default"
  task :default => [:repo, :update, :install ] do |t,arg|
    sh "sudo update-java-alternatives -s java-#{JAVA_VERSION}-oracle"
  end
end
