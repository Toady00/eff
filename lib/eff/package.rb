require 'eff/downloader'
require 'eff/template'
require 'eff/package/semantic_version'

module Eff
  class Package
    attr_accessor :save_file, :version

    def initialize(options = {})
      @url_template  = options[:url_template]
      self.save_file = options[:save_file]
      self.version   = options[:version]
      new_downloader
    end

    def download
      downloader.get
    end

    def downloaded?
      downloader.success?
    end

    def url
      template = Eff::Template.new(@url_template, version)
      template.result
    end

    def save_file=(value)
      @save_file = File.expand_path(value, Dir.pwd)
      clear_download!
    end

    def version=(value)
      @version = SemanticVersion.new(value)
      clear_download!
    end

  private
    def downloader
      @downloader
    end

    def new_downloader
      @downloader = Eff::Downloader.new(url, save_file)
    end

    def download_response
      downloader.response
    end

    def clear_download!
      new_downloader if downloader
    end
  end
end
