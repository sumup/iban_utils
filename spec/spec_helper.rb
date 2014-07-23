require 'rspec'

require './lib/iban_utils'
require './spec/shared_contexts'

# This service is only designed to work with
# IbanBic (http://www.ibancalculator.com/)
IBANBIC_API_URL = 'https://ssl.ibanrechner.de/http.html'

# Set here the test account credentials,
# or export them as ENV variables
IBANBIC_TEST_USER = ENV['IBANBIC_TEST_USER']
IBANBIC_TEST_PASSWORD = ENV['IBANBIC_TEST_PASSWORD']
