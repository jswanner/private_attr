# frozen_string_literal: true

require_relative "../private_attr"

# Module.include is private in Ruby < 2.1
Module.__send__(:include, PrivateAttr)
