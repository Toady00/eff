require 'spec_helper'
require 'eff/downloader'
require 'ostruct'
require 'fakefs/spec_helpers'

describe Eff::Downloader do
  include FakeFS::SpecHelpers

  let(:url)          { "http://google.com" }
  let(:file)         { "test.tmp" }
  let(:full_path)    { File.expand_path(file, Dir.pwd) }
  let(:fake_success) { OpenStruct.new(body: "I'm a fake response!", success?: true) }
  let(:fake_failure) { OpenStruct.new(body: "I'm a fake response!", success?: false) }
  let(:downloader)   { Eff::Downloader.new(url, file) }

  before do
    Faraday.stub(:get).and_return(fake_success)
  end

  context 'for successfull request' do
    before do
      downloader.get
    end

    describe '#get' do
      it 'saves the file' do
        File.exists?(File.expand_path(file, Dir.pwd)).should be_true
      end
    end

    describe '#success?' do
      it 'returns true' do
        downloader.should be_success
      end
    end
  end

  context 'for unsuccessfull request' do
    before do
      Faraday.stub(:get).and_return(fake_failure)
      downloader.get
    end

    describe '#get' do
      it 'does not save a file' do
        File.exists?(File.expand_path(file, Dir.pwd)).should_not be_true
      end
    end

    describe '#success?' do
      it 'returns false' do
        downloader.should_not be_success
      end
    end
  end

  describe '#uri=' do
    let(:another_url) { "http://example.com" }
    let(:another_uri) { URI(another_url) }

    it 'resets response to nil' do
      downloader.get
      downloader.response.should_not be_nil
      downloader.uri = another_url
      downloader.response.should be_nil
    end

    it 'sets the new uri' do
      downloader.uri = another_url
      downloader.uri.should eq(another_uri)
    end
  end

  describe '#file=' do
    let(:another_file) { '~/some_other_file' }

    it 'resets response to nil' do
      downloader.get
      downloader.response.should_not be_nil
      downloader.file = another_file
      downloader.response.should be_nil
    end

    it 'sets the new file' do
      downloader.file = another_file
      downloader.file.should eq(File.expand_path(another_file, Dir.pwd))
    end
  end
end
