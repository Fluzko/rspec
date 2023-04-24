module Mockeable
  @@mock = nil
  def mockear(method_to_mock, &block)
    @@mock ||= {}
    unbound_method = self.send(:instance_method, method_to_mock)
    @@mock[method_to_mock] = unbound_method
    send(:define_method, method_to_mock, block)
  end

  def mock
    @@mock
  end
end
