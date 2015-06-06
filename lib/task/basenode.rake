namespace :basenode do
  BASNODE_AMI = 'ami-81211eb1'
  desc "make a basenode AMI"
  task :mk do
    name = 'basenode'
    config = json_file name
    puts "using " + "#{config}".green
    json = JSON.parse `aws ec2 run-instances --cli-input-json file:///#{config} --output json`.strip
    File.open("/var/tmp/#{name}.json", 'w'){|f| f.write(json)}
    id = json['Instances'].first['InstanceId']
    puts id
  end

  desc "configure an instance"
  task :configure, [:instance_id] do |t,arg|
    raise "ec2 instance ID required" if arg.instance_id.nil?
    host = hostname arg.instance_id
    Dir.chdir ETC_DIR do
      sh "scp basenode.sh #{host}:"
      sh "ssh #{host} './basenode.sh'"
    end
  end

  desc 'create an image'
  task :image, [:instance_id, :name] do |t,arg|
    raise 'instance ID is required' if arg.instance_id.nil?
    arg.with_defaults(name: 'baseimage-0')
    image = YAML.load_file "#{PROJ_DIR}/etc/baseimage.json"
    image['InstanceId'] = arg.instance_id
    image['Name'] = arg.name
    File.open('/var/tmp/image.json', 'w') {|f| f.write image.to_json}
    sh "aws ec2 create-image --cli-input-json file:///var/tmp/image.json"
  end

  task :test do
    p hostname('i-a6384851')
  end
  
  def hostname(instance_id, tries=3)
    host, count = nil, 0
    begin
      json = JSON.parse `aws ec2 describe-instances --instance-id #{instance_id}`.strip
      host = json['Reservations'].first['Instances'].first['PublicDnsName']
      raise "waiting for hostname" if host.nil?
    rescue x
      count = count + 1
      if count < tries
        sleep 1
      else
        raise "no hostname for instance ID: #{arg.instance_id}"
      end
    end
    host
  end
end
