# IbanUtils

This library provides few utility classes that wrap the Iban-Bic's (http://www.ibancalculator.com/) iban services.

## Installation

Just add it to the Gemfile of your project:

    gem 'iban_utils', '>= 0.0.0'

## Usage

    validation = IbanValidation.new(config)
    validation.valigate

    generator = IbanGenerator.new(config)
    generator.generate

## Testing

To run the built-in rspec tests, run:

    bundle exec rspec ./spec

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright & License

Please read License.txt
