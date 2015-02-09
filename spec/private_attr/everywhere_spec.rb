require 'minitest/autorun'

describe 'private_attr/everywhere' do
  # these particular tests must be ran in order
  def self.test_order
    :alpha
  end

  it 'requiring only private_attr keeps Classes and Modules intact' do
    require 'private_attr'
    -> { class  Cla; private_attr_reader :priv; end }.must_raise NoMethodError
    -> { module Mod; private_attr_reader :priv; end }.must_raise NoMethodError
  end

  it 'requiring private_attr/everywhere adds it to all Classes and Modules' do
    require 'private_attr/everywhere'
    class  Cla; private_attr_reader :priv; end
    module Mod; private_attr_reader :priv; end
  end
end
