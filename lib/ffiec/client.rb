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

    # CDR Definition: Retrieves the ID RSSDs and DateTime of the reporters who have filed after a given date 
    # for a given reporting period.
    # 
    # Returns an array of hashes (keys are :id_rssd and :date_time) that contain the institutions that submitted or updated
    # filings for a specific reporting period (:reporting_period_end_date) after a given date (:last_update_datetime).\
    #
    # :reporting_period_end_date - See output of :retrieve_reporting_periods method for acceptable values
    # :date_time - A string representing a date (e.g. 01-02-2015, 01/02/2015, 2015-01-02, etc...)
    def retrieve_filers_submission_date_time(reporting_period_end_date:, last_update_datetime:)
      response = @client.call(:retrieve_filers_submission_date_time, message: {reportingPeriodEndDate: reporting_period_end_date, lastUpdateDateTime: last_update_datetime})
      return response.body[:retrieve_filers_submission_date_time_response][:retrieve_filers_submission_date_time_result][:retrieve_filers_date_time]
    end

    # Retrieves the ID RSSDs of the reporters who have filed after a given date for a given reporting period.
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
