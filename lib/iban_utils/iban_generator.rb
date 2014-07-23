class IbanGenerator
  attr_reader :response

  def initialize(config)
    @config = config

    @params = {}
    @params['function'] = 'calculate_iban'
  end

  def generate(country_code, account_number, bank_code=nil)
    @params['country'] = country_code
    @params['account'] = account_number
    @params['bankcode'] = bank_code || ""

    request = IbanRequest.new(@config)
    @response = request.submit(@params)

    response.details[:iban]
  end
end
