# TADSPEC

## Description

Small Ruby testing framework done in the context of the [TADP course](https://tadp-utn-frba.github.io/) at the University UTN-FRBA.<br/>
Provides basic functionality to write tests and run them.

## Usage

Example of how to use:

```ruby
require_relative '../lib/tadspec'
class Suite
    class Persona
        def initialize(edad)
        @edad = edad
        end

        def es_un_metodo_mockeado?
        false
        end

        def viejo?
        @edad > 29
        end
    end

    # 1 should be 1
    def testear_que_1_deberia_ser_1
    1.deberia ser 1
    end

    # Test truthiness of a method return
    def testear_que_una_persona_deberia_ser_vieja
        p = Persona.new(30)
        p.deberia ser_viejo
    end
end
```

## Test suite

A test suite is any class that contains test methods. A test method is any method that starts with the word `testear_que`.<br/>

## Assertions

### ser_igual (to be equal)

Asserts that the receiver is equal to the argument using `==` comparison.
You can use `ser` as an alias of `ser_igual`.

```ruby
def testear_que_1_es_igual_a_1
  1.deberia ser_igual 1
  1.deberia ser 1
end
```

### mayor_a || menor_a (greater than || less than)

Asserts with `>` or `<` comparison.

```ruby
def testear_que_2_es_mayor_a_1
  2.deberia ser mayor_a 1
end

def testear_que_1_es_menor_a_2
  1.deberia ser menor_a 2
end
```

### entender (responds to)

Asserts that the receiver responds to the argument.

```ruby
def testear_que_1_responde_a_to_s
  1.deberia entender :to_s
end
```

### uno_de_estos (one of)

Asserts that the receiver is equal to one of the following arguments.

```ruby
def testear_que_1_es_igual_a_1_o_2
  1.deberia ser uno_de_estos 1, 2
  4.deberia ser uno_de_estos [4,5,6]
end
```

### explotar_con (raise with)

Asserts that the receiver raises the given exception.

```ruby
def testear_que_deberia_explotar_con_ZeroDivisionError
    proc { 1 / 0 }.deberia explotar_con ZeroDivisionError
end
```

### ser\_<boolean_method>

Asserts that the receiver returns `true` after calling the given method.

```ruby
class Suite
    class Persona
        def initialize(edad)
        @edad = edad
        end

        def mayor?
        @edad > 18
        end
    end
    # Test truthiness of a method return
    def testear_que_una_persona_deberia_ser_vieja
        p = Persona.new(18)
        p.deberia ser_mayor
    end
end
```

### tener\_<attr>

Asserts that the receiver has the given attribute.

```ruby
class Suite
    class Persona
        attr_accessor :edad
        def initialize(edad)
        @edad = edad
        end
    end

    def testear_que_una_persona_deberia_tener_edad
        p = Persona.new(18)
        p.deberia tener_edad
    end
end
```

## Mock

Mock a method of an object.

```ruby
class Suite
    class Persona
        def es_un_metodo_mockeado?
        false
        end
    end

    # Test that the mock is working
    def testear_que_una_persona_deberia_mockear_un_metodo
        p = Persona.new(30)
        p.es_un_metodo_mockeado?.deberia ser false
        p.mockear :es_un_metodo_mockeado?, true
        p.es_un_metodo_mockeado?.deberia ser true
    end

    # Test that the mock respects scope
    def testear_que_respecta_scope
        p = Persona.new(28)
        p.es_un_metodo_mockeado?.deberia ser false
    end
end
```

## Spy

Gives you the ability to check if a method was called on an object.
Provides the following methods: `haber_recibido` & `con_argumentos`

```ruby
  def testear_que_espia_a_un_metodo_y
    p = Persona.new(28)
    p_spied = espiar(p)

    p_spied.mayor

    p_spied.deberia haber_recibido(:mayor).con_argumentos
  end
```
