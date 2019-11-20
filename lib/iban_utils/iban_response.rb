require 'nokogiri'

class IbanResponse
  attr_accessor :return_code, :return_message, :comment, :details, :raw

  def initialize(http_response)
    @raw = http_response
    body = http_response.body.strip
    doc = Nokogiri::XML(body, nil, 'UTF-8')
    parse(doc)
  end

  def found?
    @return_code && @return_code < 128
  end

  def passed?
    found? && @return_message && @return_message == "passed"
  end

  def status
    if found?
      passed? ? "VERIFIED" : "REVIEW"
    else
      "REJECTED"
    end
  end

  private

  def parse(response_xml)
    # The result is either a string "passed" or "failed" or "failed+reason"
    @return_message = response_xml.xpath('//result').last.content.downcase
    @return_code = response_xml.xpath('//return_code')&.first&.content.to_i
    @details = {}

    if found?
      @details[:bank] = response_xml.xpath('//bank')&.first&.content
      @details[:bank_address] = response_xml.xpath('//bank_address')&.first&.content

      xml_iban = response_xml.xpath('//iban')

      # What if we get more than one iban?
      # o_iban = [*xml_iban].length > 1 ? nil : (xml_iban&.first&.content&.empty? ? nil : xml_iban&.first&.content)
      @details[:iban] = xml_iban&.first&.content&.empty? ? nil : xml_iban&.first&.content

      xml_account_number = response_xml.xpath('//account_number')
      @details[:account_number] = xml_account_number&.first&.content&.empty? ? nil : xml_account_number&.first&.content

      xml_bank_code = response_xml.xpath('//bank_code')
      @details[:bank_code] = xml_bank_code&.first&.content&.empty? ? nil : xml_bank_code&.first&.content

      swift_candidates = response_xml.xpath('//bic_candidates-list')
      @details[:possible_bics] = swift_candidates ?
        swift_candidates.xpath('bic_candidates/bic').map { |v| v.content } : []

      # if we receive more than one swift, save the swift as nil, otherwise save the single swift.
      @details[:swift] = @details[:possible_bics].first if @details[:possible_bics].size == 1
    end

    @comment = generate_comment(@return_code, @return_message, @details)

    self
  end

  def generate_comment(return_code, return_message, details)
    comment = []
    comment << "Iban generation returned with code: #{return_code}."
    comment << "Result: #{return_message}"

    if return_code == 0 || !(return_message =~ /passed/).nil?
      comment << "Result can be assumed correct. "
    elsif return_code < 127
      comment << "VERIFY RESULT: Result might be correct but should be verified."
    end

    if details[:possible_bics] && details[:possible_bics].empty?
      # KYC Comment: no BICs found
      comment << "Received NO swift - not saving a swift value."
    elsif details[:possible_bics] && details[:possible_bics].size > 1
      # Add possible BICs to KYC logs
      comment << "Received more than one swift: #{details[:possible_bics]} - not saving a swift value."
    end

    comment << "RESPONSE Details:"
    comment << "  Status: #{return_message}"
    comment << "  Return Code: #{return_code}"

    if details
      comment << "  Bank: #{details[:bank]}"
      comment << "  Bank Address: #{details[:bank_address]}"
      comment << "  BIC Candidates: #{details[:possible_bics] ? details[:possible_bics].join(", ") : 'none'}"
    end

    comment.join("\n")
  end
end
