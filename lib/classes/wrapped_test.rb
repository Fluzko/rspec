require_relative '../utils/global'
require 'colorize'

class WrappedTestPassed
  attr_accessor :state

  def initialize(name)
    @name = name
    @state = $test_state_map[:pass]
  end

  def print
    puts "  ✓ #{@name}".green
  end
end

class WrappedTestFailure
  attr_accessor :state

  def initialize(name, exception)
    @name = name
    @exception = exception
    @state = $test_state_map[:failed]
  end

  def print
    puts "  x #{@name}".red
    puts "    - Se esperaba #{@exception.message}".red
  end
end

class WrappedTestException
  attr_accessor :state

  def initialize(name, exception)
    @name = name
    @exception = exception
    @state = $test_state_map[:exception]
  end

  def print
    puts "  x #{@name} EXPLOTO!!".red
    puts "    - #{@exception}".red
  end
end
