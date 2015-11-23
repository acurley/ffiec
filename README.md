# Ffiec

This gem is a Ruby wrapper for the FFIEC (Federal Financial Institutions Examination Council) Public Data Distribution (PDD) Public Web Service (PWS). Before using this gem you must sign up for a web services account at the [FFIEC's website](https://cdr.ffiec.gov/public/PWS/CreateAccount.aspx) where you will choose a username and be provided with an API key.

* [Documentation for the SOAP API](https://cdr.ffiec.gov/Public/PWS/WebServices/RetrievalService.asmx)
* [WSDL file](https://cdr.ffiec.gov/Public/PWS/WebServices/RetrievalService.asmx?WSDL)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ffiec'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ffiec

## Usage
```
require 'ffiec'

client = Ffiec::Client.new(username:'your_username', api_key:'your_api_key')

client.available_commands
=> [:test_user_access, :retrieve_reporting_periods, :retrieve_panel_of_reporters, :retrieve_filers_submission_date_time, :retrieve_filers_since_date, :retrieve_facsimile, :retrieve_ubpr_reporting_periods, :retrieve_ubprxbrl_facsimile]

client.test_user_access
=> true

client.retrieve_facsimile(date: '9/30/2015', format: 'SDF', id: 37, id_type: 'ID_RSSD')
=> "Call Date;Bank RSSD Identifier;MDRM #;Value;Last Update;Short Definition;Call Schedule;Line Number\r\n20150930;37;RCOA3792;20326;20151028;Total capital (sum of items 26 and 34.a)..."
```

## Development
To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/acurley/ffiec. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
