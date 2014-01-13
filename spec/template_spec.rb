require 'spec_helper'
require 'eff/template'

describe Eff::Template do
  before(:each) do
    @src      = '<%= "#{@name}, I am your father." %>'
    @erb_vars = { name: "Luke" }
  end

  let(:template) { Eff::Template.new @src, @erb_vars }

  describe '#erb_vars=' do
    it 'converts keys to instance variable keys' do
      template.instance_variable_get(:@erb_vars).should eq({ :@name => "Luke"})
    end
  end

  describe '#result' do
    it 'correctly creates the result' do
      template.result.should eq("Luke, I am your father.")
    end

    it 'handles multiple vars' do
      @src = '<%= "#{@name} - #{@age}" %>'
      @erb_vars = { name: "Luke", age: 21 }
      template.result.should eq("Luke - 21")
    end
  end
end
