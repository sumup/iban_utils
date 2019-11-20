# -*- encoding: utf-8 -*-
require File.expand_path('../lib/iban_utils/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "iban_utils"
  gem.version       = IbanUtils::VERSION
  gem.license       = "MIT"
  gem.authors       = ["SumUp Ltd"]
  gem.email         = ["support@sumup.com"]
  gem.description   = %q{This library provides few utility classes that wrap the Iban-Bic's (http://www.ibancalculator.com/) iban services.}
  gem.summary       = %q{A communication wrapper for the Iban-Bic services.}
  gem.homepage      = ""

  gem.files         = `git ls-files -- lib/*`.split("\n")
  # gem.files        += %w(README.md License.txt Changelog.md)
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.require_path = "lib"

  # Dependencies
  gem.add_dependency 'nokogiri', '1.10.4'
end
