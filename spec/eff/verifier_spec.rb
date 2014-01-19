require 'spec_helper'
require 'eff/verifier'

describe Eff::Verifier do
  let(:file)   { "spec/support/static_file_for_digesting.txt" }
  let(:sha1)   { "75cfdde12aeb435fd0c68c99df1027190953997e" }
  let(:md5)    { "1c0b1fcddc0cd9677ecfb79e1d127e03" }
  let(:hashes) { { sha1: sha1, md5: md5 } }

  describe '.check' do
    it 'returns true if the hashes match' do
      hashes.each do |hash_function, value|
        Eff::Verifier.check(file, value, hash_function).should be_true
      end
    end

    it 'returns false if the hashes do not match' do
      hashes.each do |hash_function, value|
        Eff::Verifier.check(file, "this doesn't match", hash_function).should_not be_true
      end
    end
  end
end
