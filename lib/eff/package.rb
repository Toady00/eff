require 'eff/downloader'
require 'eff/template'
require 'eff/package/semantic_version'
require 'eff/verifier'

module Eff
  class Package
    attr_accessor :name, :save_file, :version, :checksum, :hash_function

    def initialize(options = {})
      @name          = options[:name]
      @url_template  = options[:url_template]
      @file_template = options[:file_template]
      self.version   = options[:version]
      @checksum      = options[:checksum]
      @hash_function = options[:hash_function]

      after_init_hook
    end

    def download
      downloader.get
    end

    def downloaded?
      downloader_success?
    end

    def url
      template_for(:url).result
    end

    def file_name
      template_for(:file).result
    end

    def save_file
      File.expand_path(file_name, Dir.pwd)
    end

    def version=(value)
      @version = SemanticVersion.new(value)
      clear_download!
    end

    def ==(other)
      (name == other.name) && (version == other.version)
    end

    def verified?
      verifiable? ? Verifier.check(save_file, checksum, hash_function) : false
    end

    def verifiable?
      checksum && hash_function
    end

  private
    def after_init_hook
      new_downloader
    end

    def downloader
      @downloader
    end

    def new_downloader
      @downloader = Eff::Downloader.new(url, save_file)
    end

    def downloader_success?
      downloader.success?
    end

    def clear_download!
      new_downloader if downloader
    end

    def template_for(sym)
      template = instance_variable_get("@#{sym}_template".to_sym)
      Eff::Template.new(template, version)
    end
  end
end
