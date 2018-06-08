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

  #
  # @raise [EmptyIbanError]
  #
  # @return [IbanResponse]
  # Example:
  # <IbanResponse:0x007fb29c9f0c80
  # @comment=
  #   "Iban generation returned with code: 0.\nResult: passed\nResult can be assumed correct. \nRESPONSE Details:\n
  #   Status: passed\n  Return Code: 0\n  Bank: Commerzbank\n  Bank Address: 50447 Köln\n  BIC Candidates: COBADEFFXXX",
  # @details=
  #   {:bank=>"Commerzbank",
  #    :bank_address=>"50447 Köln",
  #    :iban=>"DE89370400440532013000",
  #    :account_number=>"0532013000",
  #    :bank_code=>"37040044",
  #    :possible_bics=>["COBADEFFXXX"],
  #    :swift=>"COBADEFFXXX"},
  # @raw=#<Net::HTTPOK 200 OK readbody=true>, @return_code=0, @return_message="passed">
  # >
  #
  def validate_and_get_info(iban)
    # no need to send a validation request for an obviously invalid ibans
    unless iban && iban.is_a?(String) && !iban.gsub(/\s/, '').empty?
      raise EmptyIbanError, 'Iban validation failed due to: No iban provided!'
    end

    request = IbanRequest.new(@config)
    @response = request.submit(@params.merge('iban' => iban))
  end
end
