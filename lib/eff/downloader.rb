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
      save
    end

    def success?
      response ? response.success? : false
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
    def save
      File.open(file, 'wb') do |f|
        f.write(response_body)
      end if success?
      success?
    end

    def response_body
      response.body
    end

    def clear_response!
      @response = nil
    end
  end
end
