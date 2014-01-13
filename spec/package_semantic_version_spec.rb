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
end
