require 'spec_helper'
require 'eff/downloader'
require 'ostruct'
require 'fakefs/spec_helpers'

describe Eff::Downloader do
  include FakeFS::SpecHelpers

  let(:url)          { "http://google.com" }
  let(:file)         { "test.tmp" }
  let(:full_path)   { File.expand_path(file, Dir.pwd) }
  let(:fake_success) { OpenStruct.new(body: "I'm a fake response!", success?: true) }
  let(:fake_failure) { OpenStruct.new(body: "I'm a fake response!", success?: false) }

  # describe '.get' do
  #   it 'returns the body if response is successful' do
  #     Faraday.stub(:get).and_return(fake_success)
  #     Eff::Downloader.get(url, file).should eq(fake_success.body)
  #   end

  #   it 'returns nil if the response is not successful' do
  #     Faraday.stub(:get).and_return(fake_failure)
  #     Eff::Downloader.get(url, file).should be_nil
  #   end
  # end

  # describe '.get!' do
  #   it 'writes the appropriate file' do
  #     Faraday.stub(:get).and_return(fake_success)
  #     Eff::Downloader.get!(url, file)
  #     File.exists?(File.expand_path(file, Dir.pwd)).should be_true
  #   end

  #   it 'downloads the appropriate file' do
  #     Faraday.should_receive(:get).with(URI(url)).and_return(fake_success)
  #     Eff::Downloader.get!(url, file)
  #   end

  #   it 'returns the location of the saved file' do
  #     Faraday.stub(:get).and_return(fake_success)
  #     Eff::Downloader.get!(url, file).should be_true
  #   end
  # end

  describe 'instance' do
    before { Faraday.stub(:get).and_return(fake_success) }

    let(:downloader) { Eff::Downloader.new(url, file) }

    describe '#get' do
      it 'returns a response' do
        downloader.get.should respond_to :success?
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

    describe '#file' do
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

    context 'successfully downloaded' do
      describe '#save' do
        it 'gets the response if it has not already' do
          Faraday.should_receive(:get).with(URI(url)).and_return(fake_success)
          downloader.save
        end

        it 'writes the file to disk' do
          downloader.save
          File.exists?(File.expand_path(file, Dir.pwd)).should be_true
        end
      end

      describe '#success?' do
        it 'returns true' do
          downloader.should be_success
        end
      end
    end

    context 'unsuccessfully downloaded' do
      before { Faraday.stub(:get).and_return(fake_failure) }

      describe '#save' do
        it 'gets the response if it has not already' do
          Faraday.should_receive(:get).with(URI(url)).and_return(fake_success)
          downloader.save
        end

        it 'does not write the file to disk' do
          downloader.save
          File.exists?(File.expand_path(file, Dir.pwd)).should_not be_true
        end
      end

      describe '#success?' do
        it 'returns false' do
          downloader.should_not be_success
        end
      end
    end
  end
end
