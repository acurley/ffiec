module Ffiec
  class Client
    soap_endpoint = "https://cdr.ffiec.gov/Public/PWS/WebServices/RetrievalService.asmx?WSDL"

    def initialize(options={})
      @api_key = options[:api_key]
      @username = options[:username]
    end
  end
end