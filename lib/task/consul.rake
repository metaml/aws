namespace :consul do
  DIR = "/var/tmp"

  desc "install consul package"
  task :install => [:install_consul, :install_webui]

  desc "install consul"
  task :install_consul do
    version = '0.4.0'
    url = "https://dl.bintray.com/mitchellh/consul/#{version}_linux_amd64.zip"
    Dir.chdir DIR do
      sh "sudo rm -rf consul #{url.split('/').last}"
      download url
      sh "sudo cp consul /usr/local/bin"
    end
  end
  
  task :install_webui do
    version = '0.4.0'
    url = "https://dl.bintray.com/mitchellh/consul/#{version}_web_ui.zip"
    Dir.chdir DIR do
      sh "sudo rm -rf dist #{url.split('/').last}"
      download url
      sh "sudo mkdir -p /usr/local/share/consul"
      sh "sudo cp -a dist/* /usr/local/share/consul/."
    end
  end

  def download(url)
    sh "wget #{url}"
    sh "unzip #{url.split('/').last}"
  end
end
