#!/usr/bin/ruby

module RUtils
  def expect(node, expected_type, explanation = "")
    if !node.is_a?(expected_type)
      raise "Object (#{explanation} of type #{node.class.to_s} ) should be of type #{expected_type.to_s}\n"
    end
  end
  module_function :expect
end
