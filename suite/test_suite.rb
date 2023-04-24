module TestSuite
  def run_methods(test, metodo)
    test.send metodo
    Test.deberia_list.all?(&:call)
  end

  def ser(attribute, operator)
    proc do |object|
      if operator == "mayor"
        object > attribute
      end
      if operator == "menor"
             object < attribute
           end
      if operator == "igual"
      object == attribute
    end
  end

  def ser_igual(attribute)
    ser(attribute, "igual")
  end

  def ser_mayor(attribute)
    ser(attribute, "mayor")

  end

  def ser_menor(attribute)
    ser(attribute, "menor")
  end
  end
  end

