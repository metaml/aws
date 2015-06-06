namespace :ec2 do
  require 'yaml'
  require 'json'
  
  desc "create json cli"
  task :skeleton do
    sh "aws ec2 create-image --generate-cli-skeleton"
  end

  task :keypair, [:name] do |t,arg|
    raise "name is required" if arg.name.nil?
    unless File.exist? json_file(arg.name)
      sh "aws ec2 create-key-pair --key-name #{arg.name} | tee #{json_file(arg.name)}"
    else
      raise "#{arg.name}: #{json_file(name)} alread exists".red
    end
    Rake::Task['ec2:import'].invoke(arg.name)
  end

  task :import, [:name] do |t,arg|
    raise "name is required" if arg.name.nil?
    Dir.chdir PROJ_DIR do
      kp = YAML.load_file json_file(arg.name)
      File.open(kp['KeyName'] + '.pem', 'w') {|f| f.write kp['KeyMaterial']}
      sh "openssl rsa -in #{arg.name}.pem -pubout > #{arg.name}.pub"
      pub = `cat #{arg.name}.pub|grep -v PUBLIC`.strip.split.join
      sh "aws ec2 import-key-pair --key-name #{arg.name} --public-key-material '#{pub}'"
    end
  end
end
