require 'savon'

module Ffiec
  class Client
   
    # Return new Ffiec::Client, which is really a wrapper around Savon::Client 
    def initialize(username:, api_key:)
      wsdl_endpoint = "https://cdr.ffiec.gov/Public/PWS/WebServices/RetrievalService.asmx?WSDL"
      @client = Savon.client(wsdl: wsdl_endpoint, wsse_auth: [username, api_key])
    end

    # Return array of commands that the WDL endpoint prescribes
    def available_commands
      return @client.operations
    end

    # Return array of strings that contain dates for which reports are available
    def retrieve_reporting_periods
      response = @client.call(:retrieve_reporting_periods)
      return response.body[:retrieve_reporting_periods_response][:retrieve_reporting_periods_result][:string]
    end

    # Return an array of hashes containing basic metadata for institutions that filed reports on a given reporting date.
    # 
    # Note: Many of the values returned within the hashes do not have proper spacing. It is recommended to use .strip and .squeeze to normalize values
    def retrieve_panel_of_reporters(date:)
      response = @client.call(:retrieve_panel_of_reporters, message: {reportingPeriodEndDate: date})
      return response.body[:retrieve_panel_of_reporters_response][:retrieve_panel_of_reporters_result][:reporting_financial_institution]
    end

    def retrieve_filers_submission_date_time
    end

    def retrieve_filers_since_date
    end

    # Returns the web service response already decoded using Base64.decode64. The output is ready to be written to a file or processed inline. Accepted valued for parameters are:
    # 
    # date - (See output of :retrieve_reporting_periods method for acceptable values)
    # format - Acceptable values: PDF, SDF (semicolon delimited format) and XBRL
    # id_type - Acceptable values: FDICCertNumber, ID_RSSD, OCCChartNumber and OTSDockNumber
    # id - The financial institution's ID based on the enumerated fiIDType
    def retrieve_facsimile(date:, format:, id:, id_type:)
      response = @client.call(:retrieve_facsimile, message: {reportingPeriodEndDate: date, fiID: id, facsimileFormat: format, fiIDType: id_type})
      return Base64.decode64 response.body[:retrieve_facsimile_response][:retrieve_facsimile_result]
    end

    def retrieve_ubpr_reporting_periods
    end

    def retrieve_ubprxbrl_facsimile
    end

    # Returns boolean response stating whether a user has provided valid credentials
    def test_user_access
      response = @client.call(:test_user_access)
      return response.body[:test_user_access_response][:test_user_access_result]
    end
  end
end
