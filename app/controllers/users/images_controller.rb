class Users::ImagesController < ApplicationController
  
  

  
  def show
    # отображает изображение пользователя inline 
    # на выходе имеем изображение заданного типа для заданного пользователя
    # params[:user] => id'шник пользователя
    # params[:image_type] => тип изображения: 'page_image' или 'menu_image'
    #
    # т.к. дефолтную картинку в БД не храним,
    # то читаем ее отдельно,если у самого пользователя в БД с картинками пусто
    # TODO-babrovka: что-то бы отрефакторить в этом кошмаре
    user = User.where(id: params[:user]).first
    image_type = params[:image_type]
    image = user.send(image_type) ||
            File.new(File.join(Rails.root, 'public/system', user.build_user_tmp_image.image.url(params[:image_type].gsub('_image', '')))).read
    send_data(image, :type => "image/png", :filename => 'image', :disposition => "inline")
  end

end