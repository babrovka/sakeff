class VlcManager
  
  def initialize(user, server)
    @user = user
    @server = server
  end
  
  def start
    start_command = '/home/babrovka/vlc.sh'
    exec "#{connect} #{start_command}"
  end
  
  def stop
    stop_command = 'kill `pidof vlc`'
    system "#{connect} '#{stop_command}'"
  end
  
  def connect
    "ssh #{@user}@#{@server}"
  end
    
  
end