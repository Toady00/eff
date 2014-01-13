require 'spec_helper'
require 'eff/verifier'

describe Eff::Verifier do
  let(:file) { "spec/support/static_file_for_digesting.txt" }
  let(:sha1) { "75cfdde12aeb435fd0c68c99df1027190953997e" }
  let(:md5)  { "1c0b1fcddc0cd9677ecfb79e1d127e03" }

  it 'returns true if the hashes match' do
    Eff::Verifier.check(file, sha1).should be_true
  end

  it 'returns false if the hashes do not match' do
    Eff::Verifier.check(file, "this doesn't match").should_not be_true
  end

  it 'can validate with md5' do
    Eff::Verifier.check(file, md5, Digest::MD5).should be_true
  end
end
