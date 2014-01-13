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

    def save
      downloader.save
    end

    # TODO: should this really trigger it to download?
    def downloaded?
      downloader.success?
    end

    def url
      template = Eff::Template.new(@url_template, version)
      template.result
    end

    def save_file=(value)
      @save_file = File.expand_path(value, Dir.pwd)
    end

    def version=(value)
      @version = SemanticVersion.new(value)
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
  end
end
