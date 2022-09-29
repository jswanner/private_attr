require "minitest/autorun"

describe "private_attr/everywhere" do
  # these particular tests must be run in order
  def self.test_order
    :alpha
  end

  it "requiring only private_attr keeps Classes and Modules intact" do
    require "private_attr"
    _(Class.new.private_methods).wont_include :private_attr_reader
    _(Module.new.private_methods).wont_include :private_attr_reader
  end

  it "requiring private_attr/everywhere adds it to all Classes and Modules" do
    require "private_attr/everywhere"
    _(Class.new.private_methods).must_include :private_attr_reader
    _(Module.new.private_methods).must_include :private_attr_reader
  end
end
