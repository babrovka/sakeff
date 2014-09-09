class Im::SmsPresenter 

  require 'net/http'
  
  def self.send_messages(users, message)
    
    message = URI.encode(message)
    
    users.all.each do |user|
      if user.cell_phone_number
        Im::SmsPresenter.new.send(user.cell_phone_number, message)
      end
    end
  end
    
  def send(number, message)
    uri = URI("https://cabinet.kompeito.ru/api/plain/send?login=pdv@format-c.pro&pass=kOWFLU26te6mgfGV4RRQ&from=79204148114&to=#{number}&message=#{message}")
    res = Net::HTTP.get_response(uri)
    res.code
  end

end

