require File.expand_path("#{File.dirname(__FILE__)}/lib/dev.rb")
require File.expand_path("#{File.dirname(__FILE__)}/lib/docker.rb")
Dir.glob("#{PROJ_DIR}/lib/task/*.rake"){|p| import p}

task :default do; sh "rake -T", verbose: false; end
