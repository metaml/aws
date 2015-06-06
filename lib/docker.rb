module Dokr
  def Dokr.run(image, opts ='', debug =false)
    puts opts.red
    cmd = [] 
    cmd << 'docker'
    cmd << 'run'
    unless debug
      cmd << '--detach'
    else
      # for dev/debug mode
      cmd << '--interactive=true'
      cmd << '--tty=true' 
      cmd << "--user=root"
      cmd << '--entrypoint=/bin/sh' 
    end
    cmd += opts.split(/\s+/) unless opts.nil? || opts == ''
    cmd << image
    cmd
  end

  def Dokr.hostname(cid)
    cmd = []
    cmd <<  'docker'
    cmd << 'inspect'
    cmd << "--format='{{.Config.Hostname}}'"
    cmd << cid
    cmd
    `#{cmd.join ' '}`.strip
  end
end
