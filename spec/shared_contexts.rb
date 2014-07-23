require 'rspec'

shared_context 'connection config' do
  let(:connection_config) do
    {
      "url" => IBANBIC_API_URL,
      "user" => IBANBIC_TEST_USER,
      "password" => IBANBIC_TEST_PASSWORD,
      "ssl_verify" => false
    }
  end
end

