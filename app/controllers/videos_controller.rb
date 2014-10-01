class VideosController < BaseController
  def video
  end
  
  def start
    vlc = VlcManager.new('babrovka', '192.168.2.20')
    vlc.start
    redirect_to :back, notice: 'Камера включена'
  end
  
  def stop
    vlc = VlcManager.new('babrovka', '192.168.2.20')
    vlc.stop
    redirect_to :back, notice: 'Камера выключена'
  end

end