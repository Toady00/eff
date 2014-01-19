require 'spec_helper'
require 'eff/package'
require 'fakefs/spec_helpers'

describe Eff::Package do
  include FakeFS::SpecHelpers

  let(:url_template)   { '<%= "http://example.com/package-#{@major}.#{@minor}.#{@patch}.deb" %>' }
  let(:file_template)  { '<%= "package-#{@major}.#{@minor}.#{@patch}.deb" %>' }
  let(:version)        { '1.2.3'}
  let(:options)        { { url_template: url_template, file_template: file_template, version: version } }
  let(:package)        { Eff::Package.new options }

  let(:fake_success) { OpenStruct.new(body: "I'm a fake response!", success?: true) }
  let(:fake_failure) { OpenStruct.new(body: "I'm a fake response!", success?: false) }

  subject { package }

  before { Faraday.stub(:get).and_return(fake_success) }

  it { should respond_to :name          }
  it { should respond_to :download      }
  it { should respond_to :downloaded?   }
  it { should respond_to :url           }
  it { should respond_to :file_name     }
  it { should respond_to :save_file     }
  it { should respond_to :version       }
  it { should respond_to :checksum      }
  it { should respond_to :hash_function }
  it { should respond_to :verified?     }
  it { should respond_to :verifiable?   }

  describe 'downloader wrapper method' do
    describe '#download' do
      it 'calls Eff::Downloader#get' do
        Eff::Downloader.any_instance.should_receive(:get)
        package.download
      end
    end

    describe '#downloaded?' do
      it 'calls Eff::Downloader#success?' do
        Eff::Downloader.stub(:previously_downloaded?)
        Eff::Downloader.any_instance.should_receive(:success?)
        package.downloaded?
      end
    end
  end

  describe '#url' do
    let(:url) { 'http://example.com/package-1.2.3.deb' }

    it 'returns the correct url' do
      package.url.should eq(url)
    end
  end

  describe '#version=' do
    before do
      package.download
      package.should be_downloaded
    end

    let(:new_version)    { '4.5.6' }
    let(:package_name)   { "package-#{new_version}.deb"}
    let(:url)            { "http://example.com/#{package_name}" }
    let(:full_save_path) { File.expand_path(package_name, Dir.pwd) }

    it 'forgets about previous downloads' do
      package.version = new_version
      package.should_not be_downloaded
    end

    it 'updates the url' do
      old_url = package.url
      package.version = new_version
      package.url.should_not eq old_url
    end

    it 'creates a new downloader with the correct url' do
      Eff::Downloader.should_receive(:new).with(url, full_save_path)
      package.version = new_version
    end
  end

  describe 'verification' do
    let(:package) { Eff::Package.new @options }

    describe '#verifiable?' do
      it 'returns false without checksum or hash_function' do
        @options = options
        package.should_not be_verifiable
      end

      it 'returns false without checksum' do
        @options = options.merge(hash_function: 'sha1')
        package.should_not be_verifiable
      end

      it 'returns false without hash_function' do
        @options = options.merge(checksum: 'some_string')
        package.should_not be_verifiable
      end

      it 'returns tru with checksum and hash_function' do
        @options = options.merge(checksum: 'some_string', hash_function: 'sha1')
        package.should be_verifiable
      end
    end

    describe '#verified?' do
      it 'returns false if not verifiable' do
        @options = options
        package.should_not be_verified
      end

      it 'calls Verifier.check if verifiable' do
        @options = options.merge(checksum: 'some_string', hash_function: 'sha1')
        Eff::Verifier.should_receive(:check).with(package.save_file, package.checksum, package.hash_function)
        package.verified?
      end
    end
  end
end
