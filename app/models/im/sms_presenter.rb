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
    raise 'config/sms.yml configuration file is missing' unless File.exist?('config/sms.yml')
    sms_config = YAML.load_file('config/sms.yml').symbolize_keys!

    uri = URI("https://gate.smsaero.ru/send/?to=#{number}&text=#{message}&user=#{sms_config[:user]}&password=#{sms_config[:password]}&from=SAKE")
    request = Net::HTTP::Get.new uri.request_uri
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res = http.start { |h| h.request(request) }
    SMS_LOGGER.info("#{res.code} #{res.body}")
  end
end

