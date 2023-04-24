require_relative './wrapped_test'
require_relative '../utils/global'

class WrappedSuite
  def initialize(suite)
    @suite = suite
    @reporte = []
  end

  def clear_mocks(suite)
    suite.constants
         .collect { |c| suite.const_get c }
         .each do |a_class|
      a_class.instance_methods(false)
             .select{|a_method| a_class.mock.is_a?(Hash) && a_class.mock.key?(a_method)}
             .each do |mocked_method|
        unbounded_method = a_class.mock[mocked_method]
        a_class.send(:define_method, mocked_method, unbounded_method)
      end
        # original_method_name = mocked_method.to_s.sub 'mocked_', ''
        #a_class.send(:define_method, original_method_name, a_class.instance_method(mocked_method))
        # Difference between remove_method and undef_method:
        # https://til.hashrocket.com/posts/ealtf3gbdm-undefmethod-vs-removemethod
        #a_class.send(:remove_method, mocked_method)
        #end
    end
  end

  def run
    suite_instance = @suite.new
    test_methods = suite_instance.methods.select { |un_metodo| un_metodo.to_s.start_with?($test_method_prefix) }
    test_methods.each do |x|
      suite_instance.send(x)
      @reporte << WrappedTestPassed.new(x)
    rescue MatcherFailedException => e
      @reporte << WrappedTestFailure.new(x, e)
    rescue StandardError => e
      @reporte << WrappedTestException.new(x, e)
    ensure
      clear_mocks(@suite)
    end

    puts "\n"
    puts @suite.to_s
    @reporte.each { |r| r.print }
    passed_tests = @reporte.select { |r| r.state == $test_state_map[:pass] }
    failed_tests = @reporte.select { |r| r.state == $test_state_map[:failed] }
    exception_tests = @reporte.select { |r| r.state == $test_state_map[:exception] }
    { passed: passed_tests.length, failed: failed_tests.length, exception: exception_tests.length }
  end
end
