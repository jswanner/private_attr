require "private_attr/version"

module PrivateAttr
  def private_attr_accessor *attr
    private_attr_reader *attr
    private_attr_writer *attr
  end

  def private_attr_reader *attr
    attr_reader *attr
    private *attr
  end

  def private_attr_writer *attr
    attr_writer *attr
    private *attr.map { |a| "#{a}=" }
  end

  def protected_attr_accessor *attr
    protected_attr_reader *attr
    protected_attr_writer *attr
  end

  def protected_attr_reader *attr
    attr_reader *attr
    protected *attr
  end

  def protected_attr_writer *attr
    attr_writer *attr
    protected *attr.map { |a| "#{a}=" }
  end
end
