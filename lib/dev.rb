require 'rubygems'
require 'bundler/setup'
require 'date'
require 'yaml'
require 'smart_colored/extend'

# utils

def json_file(name)
  "#{ETC_DIR}/#{name}.json"
end

def sys_name
  s = `uname -s`.strip.downcase
  s = `lsb_release --id`.split.last.strip.downcase if 'linux' == s
  s
end

def sys_name?(p)
  sys_name == p.strip.downcase
end

def platform?(p)
  `uname -s`.strip.downcase == p.downcase
end

def proj_dir(subdir =nil)
  path = [] << PROJ_DIR
  path << subdir unless subdir.nil?
  path.join('/')
end

def process_running?(name, argfilter =nil)
  require 'sys/proctable'
  include Sys
  ProcTable.ps do |proc|
    # @todo: gross--refactor
    if argfilter.nil?
      return true if proc.comm == name
    else
      return true if proc.comm == name && proc.cmdline.split.include?(argfilter)
    end
  end
  false
end

def install_pkg(pkgs =[], sysname =sys_name)
  update, install = case sysname
                    when 'centos'
                      ['sudo yum update -y', 'sudo yum install -y']
                    when 'darwin'
                      ['brew update -y', 'brew install']
                    when 'ubuntu'
                      ['sudo apt-get update -y', 'sudo apt-get install -y']
                    else
                      raise "unknown system--not in {centos,darwin,ubuntu}"
                    end
  sh "#{update}"
  sh "#{install} #{pkgs.join(' ')}"
end

def version(bin, arg ='--version')
  puts `which #{bin}`.strip.green
  `#{bin} #{arg}`.split(/\n/).map{|l|puts "- #{l.strip}".yellow}
end

os = `uname -s`.strip.downcase
OS = case os
     when 'darwin'; 'osx'
     when 'linux'; 'linux'
     else raise "unknown OS: #{os}"
     end

PROJ_DIR = File.expand_path("#{File.dirname(__FILE__)}/../.")
_path = []
_path << "#{PROJ_DIR}/bin"
_path << '/usr/local/bin' << '/usr/bin' << '/bin'
_path << '/usr/local/sbin' << '/usr/sbin'

LIB_DIR = proj_dir 'lib'
ETC_DIR = proj_dir 'etc'
TASK_DIR = proj_dir 'lib/task'
DOCKER_DIR = proj_dir 'docker'
CLOUD_DIR = proj_dir 'docker' # aws cloud-formation

ENV['SHELL'] = '/bin/bash'
ENV['PATH'] = _path.join(':')
ENV['JAVA_HOME'] = '/usr/lib/jvm/java-8-oracle'
