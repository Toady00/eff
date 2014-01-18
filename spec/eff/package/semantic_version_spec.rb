require 'spec_helper'
require 'eff/package/semantic_version'

describe Eff::Package::SemanticVersion do
  describe '#to_h' do
    let(:version_hash) {
      Hash[
        :major,    "1",
        :minor,    "2",
        :patch,    "3",
        :release,  "p456",
        :identity, "7890"
      ]
    }
    let(:valid_versions) { %w(1 1.2 1.2.3 1.2.3-p456 1.2.3-p456+7890) }

    it 'should return the correct hash' do
      valid_versions.each do |version_string|
        semver = Eff::Package::SemanticVersion.new version_string
        hash = semver.to_h
        first_nil = false
        version_hash.each do |part, value|
          hash_value = hash[part]
          first_nil ||= hash_value.nil?
          if first_nil
            hash[part].should be_nil
          else
            hash[part].should eq(value)
          end
        end
      end
    end
  end

  describe '#<=>' do
    before do
      @versions = []
      %w(0.0.1 0.0.5 0.1.0 1.0.0 1.0.1 1.2.0 2.0.0).each do |version|
        @versions << Eff::Package::SemanticVersion.new(version)
      end
    end

    it 'compares versions correctly' do
      @versions.each_with_index do |version, index|
        @versions.each_with_index do |other, other_index|
          if index > other_index
            (version > other).should be_true
            (version < other).should be_false
            (version == other).should be_false
            (version != other).should be_true
          elsif index < other_index
            (version > other).should be_false
            (version < other).should be_true
            (version == other).should be_false
            (version != other).should be_true
          else
            (version > other).should be_false
            (version < other).should be_false
            (version == other).should be_true
            (version != other).should be_false
          end
        end
      end
    end
  end
end
