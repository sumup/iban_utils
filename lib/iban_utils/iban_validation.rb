class IbanValidation
  attr_reader :response

  class EmptyIbanError < StandardError; end

  def initialize(config)
    @config = config

    @params = {}
    @params['function'] = 'validate_iban'
  end

  def validate(iban)
    validate_and_get_info(iban)

    @response.passed?
  end

  def validate_and_get_info(iban)
    # no need to send a validation request for an obviously invalid ibans
    unless iban && iban.is_a?(String) && !iban.gsub(/\s/, '').empty?
      raise EmptyIbanError, 'Iban validation failed due to: No iban provided!'
    end

    request = IbanRequest.new(@config)
    @response = request.submit(@params.merge('iban' => iban))
  end
end
