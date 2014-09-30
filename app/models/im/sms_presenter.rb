class Im::SmsPresenter 
  require 'net/http'
  
  def self.send_messages(users, message)
    message = URI.encode(message)
    
    users.all.each do |user|
      unless user.cell_phone_number.nil? || user.cell_phone_number.empty?
        Im::SmsPresenter.send_message(user.cell_phone_number, message)
      end
    end
  end
    
  def self.send_message(number, message)
    uri = URI("https://cabinet.kompeito.ru/api/plain/send?login=pdv@format-c.pro&pass=kOWFLU26te6mgfGV4RRQ&from=79204148114&to=#{number}&message=#{message}")
    request = Net::HTTP::Get.new uri.request_uri
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res = http.start { |h| h.request(request) }
    SMS_LOGGER.info("#{res.code} #{uri}")
  end
end

