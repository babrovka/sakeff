# Патч,чтобы при работе этого сервера с Faye через SSL не выбрасывало ошибку SSLv3 Permission denied
module PrivatePub

  class << self
    # Sends the given message hash to the Faye server using Net::HTTP.
    def publish_message(message)
      raise Error, "No server specified, ensure private_pub.yml was loaded properly." unless config[:server]
      url = URI.parse(config[:server])

      form = Net::HTTP::Post.new(url.path.empty? ? '/' : url.path)
      form.set_form_data(:message => message.to_json)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = url.scheme == "https"
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.start { |h| h.request(form) }
    end

  end

end
