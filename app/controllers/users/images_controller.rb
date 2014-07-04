class Users::ImagesController < BaseController
  
  def show
    user = User.find(params[:user])
    image_type = params[:image_type]
    image = user.send(image_type)
    send_data(image, :type => "image/png", :filename => 'image', :disposition => "inline")
  end

end