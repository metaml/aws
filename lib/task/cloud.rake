namespace :cloud do
  desc "make a cloud-formation cluster"
  task :mk, [:name, :template, :vpc_id] do |t,arg|
    arg.with_defaults(:name => 'zookeeper', :template => 'zookeeper.json', :vpc_id => 'vpc-53823d36')
    cmd = [] << 'aws cloudformation'
    cmd << 'create-stack'
    cmd << "--stack-name #{arg.name}"
    cmd << "--template-body file://#{PROJ_DIR}/cloud/#{arg.template}"
    cmd << '--capabilities CAPABILITY_IAM'
    cmd << '--parameters'
    cmd << "ParameterKey=InstanceType,ParameterValue='m3.xlarge'"
    cmd << "ParameterKey=KeyName,ParameterValue='us-west-2'"
    cmd << "ParameterKey=AvailabilityZones,ParameterValue='us-west-2c'"
    cmd << "ParameterKey=ExhibitorS3Bucket,ParameterValue='cloudexhibitor'"
    cmd << "ParameterKey=ExhibitorS3Region,ParameterValue='us-west-2'"
    cmd << "ParameterKey=ExhibitorS3Prefix,ParameterValue='zookeeper'"
    cmd << "ParameterKey=VpcId,ParameterValue='#{arg.vpc_id}'"
    cmd << "ParameterKey=Subnets,ParameterValue='subnet-6527ef3c'"
    cmd << "ParameterKey=AdminSecurityGroup,ParameterValue='sg-c6043ca3'"
    sh cmd.join ' '
  end

  desc "verify a template"
  task :verify, [:name, :vpc_id] do |t,arg|
    arg.with_defaults(:name => 'zookeeper', :vpc_id => 'vpc-53823d36')
    cmd = [] << 'aws cloudformation'
    cmd << 'validate-template'
    cmd << "--template-body file://#{PROJ_DIR}/cloud/#{arg.name}.json"
    sh cmd.join ' '
  end
end
