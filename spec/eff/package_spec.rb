require 'spec_helper'
require 'eff/package'
require 'fakefs/spec_helpers'

describe Eff::Package do
  include FakeFS::SpecHelpers

  let(:url_template)   { '<%= "http://example.com/package-#{@major}.#{@minor}.#{@patch}.deb" %>' }
  let(:url)            { 'http://example.com/package-1.2.3.deb' }
  let(:save_file)      { 'example.txt' }
  let(:full_save_path) { File.expand_path(save_file, Dir.pwd) }
  let(:version)        { '1.2.3'}
  let(:options)        { { url_template: url_template, save_file: save_file, version: version } }
  let(:package)        { Eff::Package.new options }

  let(:fake_success) { OpenStruct.new(body: "I'm a fake response!", success?: true) }
  let(:fake_failure) { OpenStruct.new(body: "I'm a fake response!", success?: false) }

  subject { package }

  before { Faraday.stub(:get).and_return(fake_success) }

  it { should respond_to :name }
  it { should respond_to :download }
  it { should respond_to :downloaded? }
  it { should respond_to :url }
  it { should respond_to :save_file }
  it { should respond_to :version }
  it { should respond_to :checksum }
  it { should respond_to :digest_algo }

  describe 'downloader wrapper method' do
    describe '#download' do
      it 'calls Eff::Downloader#get' do
        Eff::Downloader.any_instance.should_receive(:get)
        package.download
      end
    end

    describe '#downloaded?' do
      it 'calls Eff::Downloader#success?' do
        Eff::Downloader.any_instance.should_receive(:success?)
        package.downloaded?
      end
    end
  end

  describe '#url' do
    it 'returns the correct url' do
      package.url.should eq(url)
    end
  end

  describe 'setter' do
    before do
      package.download
      package.should be_downloaded
    end

    describe '#save_file=' do
      let(:new_save_file) { File.expand_path('new_save_file.txt', Dir.pwd) }

      it 'forgets about previous downloads' do
        package.save_file = new_save_file
        package.should_not be_downloaded
      end

      it 'creates a new downloader with the correct save file' do
        Eff::Downloader.should_receive(:new).with(url, new_save_file)
        package.save_file = new_save_file
      end
    end

    describe '#version=' do
      let(:new_version) { '4.5.6' }
      let(:url)         { 'http://example.com/package-4.5.6.deb' }

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
  end
end
