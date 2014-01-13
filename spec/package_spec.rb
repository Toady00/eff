require 'spec_helper'
require 'eff/package'
require 'fakefs/spec_helpers'

describe Eff::Package do
  include FakeFS::SpecHelpers

  let(:url_template)   { '<%= "http://example.com/package-#{@major}.#{@minor}.#{@patch}.deb" %>' }
  let(:url)            { 'http://example.com/package-1.2.3.deb' }
  let(:save_file)      { '~/example.txt' }
  let(:full_save_path) { File.expand_path(save_file, Dir.pwd) }
  let(:version)        { '1.2.3'}
  let(:options)        { { url_template: url_template, save_file: save_file, version: version } }
  let(:package)        { Eff::Package.new options }

  let(:fake_success) { OpenStruct.new(body: "I'm a fake response!", success?: true) }
  let(:fake_failure) { OpenStruct.new(body: "I'm a fake response!", success?: false) }

  subject { package }

  before { Faraday.stub(:get).and_return(fake_success) }

  it { should respond_to :download }
  it { should respond_to :save }
  it { should respond_to :downloaded? }
  it { should respond_to :url }
  it { should respond_to :save_file }
  it { should respond_to :version }

  describe 'downloader wrapper method' do
    describe '#download' do
      it 'calls #get' do
        Eff::Downloader.any_instance.should_receive(:get)
        package.download
      end
    end

    describe '#save' do
      it 'calls #save' do
        Eff::Downloader.any_instance.should_receive(:save)
        package.save
      end
    end

    describe '#downloaded?' do
      it 'calls success?' do
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
end
