require 'uri'

class IbanRequest
  def initialize(config)
    @uri = URI.parse(config['url'])
    @ssl_verify = config['ssl_verify']
    @params = { 'user' => config['user'], 'password' => config['password'] }
  end

  def submit(params)
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true if @uri.scheme == 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE unless @ssl_verify

    @request = Net::HTTP::Post.new(@uri.request_uri)
    @request.set_form_data(@params.merge(params))

    response = http.request(@request)
    IbanResponse.new(response)
  end
end
