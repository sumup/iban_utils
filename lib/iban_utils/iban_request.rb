require 'digest'
require 'uri'
require 'net/http'

class IbanRequest
  def initialize(config)
    @uri = URI.parse(config['url'])
    @ssl_verify = config['ssl_verify']
    @params = { 'user' => config['user'], 'password' => config['password'] }
  end

  def submit(params)
    http = IbanRequest.http(@uri)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE unless @ssl_verify

    @request = Net::HTTP::Post.new(@uri.request_uri)
    @request.set_form_data(hash_password(params))

    response = http.request(@request)
    IbanResponse.new(response)
  end

  def hash_password(params)
    params = @params.merge(params)
    password = params['function'] + params['user']
    password << case params['function']
                when 'calculate_iban' then params['account']
                when 'validate_iban' then params['iban']
                else fail "Unknown function: #{params['function']}"
                end
    password << params['password']
    params['password'] = Digest::MD5.hexdigest(password)
    params
  end
  private :hash_password

  # @param   uri [URI]  endpoint address the HTTP client should connect to
  # @return  [Net::HTTP]  HTTP client to use for connecting to the given URL.
  #   If the host or port of any previously initialized client differ from
  #   the given URL, the previous session will be finished and new one
  #   started.
  def self.http(uri)
    client = @@http_client
    return client if same_endpoint?(client, uri)

    client && client.finish rescue nil

    client = Net::HTTP.new(uri.host, uri.port)
    client.use_ssl = true if uri.scheme == 'https'
    client.keep_alive_timeout = 15
    client.start
    @@http_client = client
  end

  def self.same_endpoint?(client, uri)
    return false unless client

    client.address == uri.host &&
        client.port == uri.port &&
        client.use_ssl? == (uri.scheme == 'https')
  end
  private_class_method :same_endpoint?

  @@http_client = nil

end
