require 'faraday'

module Eff
  class Downloader
    attr_reader :uri, :file, :response

    def initialize(url, file)
      self.uri  = URI(url)
      self.file = file
    end

    def get
      @response = Faraday.get(uri)
    end

    def save
      File.open(file, 'wb') do |f|
        f.write(response_body)
      end if success?
    end

    # TODO: should this really trigger it to download?
    def success?
      get unless response
      @response.success?
    end

    def file=(value)
      clear_response!
      @file = File.expand_path(value, Dir.pwd)
    end

    def uri=(value)
      clear_response!
      @uri = URI(value)
    end

  private
    def response_body
      response.body
    end

    def clear_response!
      @response = nil
    end
  end
end
