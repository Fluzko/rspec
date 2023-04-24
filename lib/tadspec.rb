require_relative 'utils/global'
require_relative 'classes/matcher_failed_exception'
require_relative 'classes/wrapped_test'
require_relative 'classes/wrapped_suite'
require_relative 'modules/matcheable'
require_relative 'modules/mockeable'
require_relative 'modules/spyable'
require 'colorize'

class TADsPec
  def self.testear(*params)
    suites = suites_to_test(*params)
    run_test(suites)
  end

  def self.run_test(suites)
    results = suites
              .map { |a_suite| WrappedSuite.new(a_suite) }
              .map { |a_suite| a_suite.run }
    total_passed = results.sum { |result_hash| result_hash[:passed] }
    total_failed = results.sum { |result_hash| result_hash[:failed] }
    total_exceptions = results.sum { |result_hash| result_hash[:exception] }

    puts "\n"
    puts '=== Resultados globales ==='.blue
    puts "Pasaron: #{total_passed}".blue
    puts "Fallaron: #{total_failed}".blue
    puts "Lanzaron una excepcion: #{total_exceptions}".blue
    puts '==========================='.blue
  end

  def self.all_classes
    # Saca "SortedSet" porque no esta definida a partir de ruby 3
    # https://github.com/ruby/set/pull/2
    Object.constants
          .reject { |c| c == :SortedSet }
          .collect { |c| Object.const_get c }
          .select { |c| c.is_a? Class }
  end

  def self.a_test_suite?(a_class)
    a_class.instance_methods(false).any? { |a_method| a_method.to_s.start_with?($test_method_prefix) }
  end

  def self.a_test_method_at?(a_class, method_name_suffix)
    expected_method_name = :"#{$test_method_prefix}#{method_name_suffix}"
    a_class.instance_methods(false).any? { |a_method| a_method == expected_method_name }
  end

  def self.suites_to_test(*params)
    class_to_test, *methods_to_test = params

    # TODO: aca va un strategy

    # Si no te pasan ninguna clase
    return all_classes.select { |a_suite| a_test_suite? a_suite } unless class_to_test

    # Si te pasan una clase pero no metodo

    return a_test_suite?(class_to_test) ? [class_to_test] : [] if methods_to_test.empty?

    # Clase + metodos
    methods_to_test.any? { |a_method| a_test_method_at?(class_to_test, a_method) } ? [class_to_test] : []
  end
end

class Object
  include Spyable
  include Matcheable
end

class Class
  include Mockeable
end

class Proc
  include Matcheable
end
