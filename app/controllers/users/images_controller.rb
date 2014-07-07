class Users::ImagesController < BaseController
  
  

  
  def show
    # отображает изображение пользователя inline 
    # на выходе имеем изображение заданного типа для заданного пользователя
    # params[:user] => id'шник пользователя
    # params[:image_type] => тип изображения: 'page' или 'menu'
    user = User.find(params[:user])
    image_type = params[:image_type]
    image = user.send(image_type)
    send_data(image, :type => "image/png", :filename => 'image', :disposition => "inline")
  end

end