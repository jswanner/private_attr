require "minitest/autorun"
require "private_attr"

class Dummy
  def read_accessor
    accessor
  end

  def read_accessor_other(other)
    other.accessor
  end

  def write_accessor(value)
    self.accessor = value
  end

  def write_accessor_other(other, value)
    other.accessor = value
  end

  def read_reader
    reader
  end

  def read_reader_other(other)
    other.reader
  end

  def write_writer(value)
    self.writer = value
  end

  def write_writer_other(other, value)
    other.writer = value
  end

  attr_reader :original

  def call_aliased
    aliased
  end

  def call_aliased_other(other)
    other.aliased
  end
end

class PrivateDummy < Dummy
  extend PrivateAttr
  private_attr_accessor :accessor
  private_attr_reader :reader
  private_attr_writer :writer
  private_alias_method :aliased, :original
end

class ProtectedDummy < Dummy
  extend PrivateAttr
  protected_attr_accessor :accessor
  protected_attr_reader :reader
  protected_attr_writer :writer
  protected_alias_method :aliased, :original
end

describe PrivateAttr do
  let(:dummy) { dummy_class.new }
  let(:other) { dummy_class.new }
  let(:old_value) { "old value" }
  let(:new_value) { "new value" }

  describe "private_attr_accessor" do
    let(:dummy_class) { PrivateDummy }

    before { dummy.instance_variable_set "@accessor", old_value }

    it "allows attribute to be read internally" do
      _(dummy.read_accessor).must_equal old_value
    end

    it "allows attribute to be written internally" do
      dummy.write_accessor new_value
      _(dummy.instance_variable_get("@accessor")).must_equal new_value
    end

    it "raises Error when read externally" do
      _{ dummy.accessor }.must_raise NoMethodError
    end

    it "raises Error when written externally" do
      _{ dummy.accessor = new_value }.must_raise NoMethodError
    end

    it "raises Error when read by other" do
      _{ dummy.read_accessor_other other }.must_raise NoMethodError
    end

    it "raises Error when written by other" do
      _{ dummy.write_accessor_other other, new_value }.must_raise NoMethodError
    end
  end

  describe "private_attr_reader" do
    let(:dummy_class) { PrivateDummy }

    before { dummy.instance_variable_set "@reader", old_value }

    it "allows attribute to be read internally" do
      _(dummy.read_reader).must_equal old_value
    end

    it "raises Error when written internally" do
      _{ dummy.write_reader new_value }.must_raise NoMethodError
    end

    it "raises Error when read externally" do
      _{ dummy.reader }.must_raise NoMethodError
    end

    it "raises Error when written externally" do
      _{ dummy.reader = new_value }.must_raise NoMethodError
    end

    it "raises Error when read by other" do
      _{ dummy.read_reader_other other }.must_raise NoMethodError
    end

    it "raises Error when written by other" do
      _{ dummy.write_reader_other other, new_value }.must_raise NoMethodError
    end
  end

  describe "private_attr_writer" do
    let(:dummy_class) { PrivateDummy }

    before { dummy.instance_variable_set "@writer", old_value }

    it "raises Error when read internally" do
      _{ dummy.read_writer }.must_raise NoMethodError
    end

    it "allows attribute to be written internally" do
      dummy.write_writer new_value
      _(dummy.instance_variable_get("@writer")).must_equal new_value
    end

    it "raises Error when read externally" do
      _{ dummy.writer }.must_raise NoMethodError
    end

    it "raises Error when written externally" do
      _{ dummy.writer = new_value }.must_raise NoMethodError
    end

    it "raises Error when read by other" do
      _{ dummy.read_writer_other other }.must_raise NoMethodError
    end

    it "raises Error when written by other" do
      _{ dummy.write_writer_other other, new_value }.must_raise NoMethodError
    end
  end

  describe "private_alias_method" do
    let(:dummy_class) { PrivateDummy }

    before { dummy.instance_variable_set "@original", old_value }

    it "allows alias to be called internally" do
      _(dummy.call_aliased).must_equal old_value
    end

    it "raises Error when alias is called externally" do
      _{ dummy.aliased other }.must_raise NoMethodError
    end

    it "raises Error when alias is called by other" do
      _{ dummy.call_aliased_other other }.must_raise NoMethodError
    end

    it "allows the original method to be called externally" do
      _(dummy.original).must_equal old_value
    end

    describe "when the original method is overridden" do
      let(:dummy_class) do
        mod = Module.new do
          def original
            super.upcase
          end
        end
        Class.new(PrivateDummy).send(:include, mod)
      end

      it "allows alias to be called internally" do
        _(dummy.call_aliased).must_equal old_value
      end

      it "raises Error when alias is called externally" do
        _{ dummy.aliased }.must_raise NoMethodError
      end

      it "raises Error when alias is called by other" do
        _{ dummy.call_aliased_other other }.must_raise NoMethodError
      end

      it "allows the overridden method to be called externally" do
        _(dummy.original).must_equal old_value.upcase
      end
    end
  end

  describe "protected_attr_accessor" do
    let(:dummy_class) { ProtectedDummy }

    before { dummy.instance_variable_set "@accessor", old_value }

    it "allows attribute to be read internally" do
      _(dummy.read_accessor).must_equal old_value
    end

    it "allows attribute to be written internally" do
      dummy.write_accessor new_value
      _(dummy.instance_variable_get("@accessor")).must_equal new_value
    end

    it "raises Error when read externally" do
      _{ dummy.accessor }.must_raise NoMethodError
    end

    it "raises Error when written externally" do
      _{ dummy.accessor = new_value }.must_raise NoMethodError
    end

    it "allows attribute to be read by other" do
      other.instance_variable_set "@accessor", new_value
      _(dummy.read_accessor_other(other)).must_equal new_value
    end

    it "allows attribute to be written by other" do
      dummy.write_accessor_other other, new_value
      _(other.instance_variable_get("@accessor")).must_equal new_value
    end
  end

  describe "protected_attr_reader" do
    let(:dummy_class) { ProtectedDummy }

    before { dummy.instance_variable_set "@reader", old_value }

    it "allows attribute to be read internally" do
      _(dummy.read_reader).must_equal old_value
    end

    it "raises Error when written internally" do
      _{ dummy.write_reader new_value }.must_raise NoMethodError
    end

    it "raises Error when read externally" do
      _{ dummy.reader }.must_raise NoMethodError
    end

    it "raises Error when written externally" do
      _{ dummy.reader = new_value }.must_raise NoMethodError
    end

    it "allows attribute to be read by other" do
      other.instance_variable_set "@reader", new_value
      _(dummy.read_reader_other(other)).must_equal new_value
    end

    it "raises Error when written by other" do
      _{ dummy.write_reader_other other, new_value }.must_raise NoMethodError
    end
  end

  describe "protected_attr_writer" do
    let(:dummy_class) { ProtectedDummy }

    before { dummy.instance_variable_set "@writer", old_value }

    it "raises Error when read internally" do
      _{ dummy.read_writer }.must_raise NoMethodError
    end

    it "allows attribute to be written internally" do
      dummy.write_writer new_value
      _(dummy.instance_variable_get("@writer")).must_equal new_value
    end

    it "raises Error when read externally" do
      _{ dummy.writer }.must_raise NoMethodError
    end

    it "raises Error when written externally" do
      _{ dummy.writer = new_value }.must_raise NoMethodError
    end

    it "raises Error when read by other" do
      _{ dummy.read_writer_other other }.must_raise NoMethodError
    end

    it "allows attribute to be written by other" do
      dummy.write_writer_other other, new_value
      _(other.instance_variable_get("@writer")).must_equal new_value
    end
  end

  describe "protected_alias_method" do
    let(:dummy_class) { ProtectedDummy }
    let(:other_value) { "other value" }

    before do
      dummy.instance_variable_set "@original", old_value
      other.instance_variable_set "@original", other_value
    end

    it "allows alias to be called internally" do
      _(dummy.call_aliased).must_equal old_value
    end

    it "raises Error when alias is called externally" do
      _{ dummy.aliased }.must_raise NoMethodError
    end

    it "allows alias to be called by other" do
      _(dummy.call_aliased_other(other)).must_equal other_value
    end

    it "allows the original method to be called externally" do
      _(dummy.original).must_equal old_value
    end

    describe "when the original method is overridden" do
      let(:dummy_class) do
        mod = Module.new do
          def original
            super.upcase
          end
        end
        Class.new(ProtectedDummy).send(:include, mod)
      end

      it "allows alias to be called internally" do
        _(dummy.call_aliased).must_equal old_value
      end

      it "raises Error when alias is called externally" do
        _{ dummy.aliased }.must_raise NoMethodError
      end

      it "allows alias to be called by other" do
        _(dummy.call_aliased_other(other)).must_equal other_value
      end

      it "allows the overridden method to be called externally" do
        _(dummy.original).must_equal old_value.upcase
      end
    end
  end

  describe "method visibility" do
    it "extending classes does not increase their public APIs" do
      _(PrivateDummy.public_methods).wont_include :private_attr_accessor
    end
  end
end
