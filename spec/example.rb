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
  class Persona2 < Persona
    def viejosss
      @edad > 29
    end
  end


  def testear_que_1_deberia_ser_1
    1.deberia ser 1
  end

  def testear_que_1_deberia_ser_menor_a_2
    1.deberia ser menor_a 2
  end

  def testear_que_2_deberia_ser_menor_a_1_FALLA
    2.deberia ser menor_a 1
  end

  def testear_que_una_persona_deberia_ser_vieja
    p = Persona.new(30)
    p.deberia ser_viejo
  end

  def testear_que_una_persona_deberia_ser_vieja_FALLA
    p = Persona.new(28)
    p.deberia ser_viejo
  end

  def testear_que_deberia_explotar_con_ZeroDivisionError
    proc { 1 / 0 }.deberia explotar_con ZeroDivisionError
  end

  def testear_que_falla_el_test_porque_explota_con_ZeroDivisionError
    proc { 1 / 0 }.deberia explotar_con NoMethodError
  end

  def testear_que_funciona_el_mock
    Persona.mockear(:es_un_metodo_mockeado?) { true }
    p = Persona.new(28)
    p.es_un_metodo_mockeado?.deberia ser true
  end

  def testear_que_se_borran_los_mocks
    p = Persona.new(28)
    p.es_un_metodo_mockeado?.deberia ser false
  end
  def testear_que_funciona_polimorfico_con
    p = Persona2.new(28)
    p.deberia ser polimorfico_con Persona
  end
end

class SuiteSpy
  class Persona
    attr_accessor :edad

    def initialize(una_edad)
      @edad = una_edad
    end

    def viejo
      edad > 29
    end
  end

  def testear_que_espia_a_un_metodo_y
    p = Persona.new(28)
    p_spied = espiar(p)

    p_spied.viejo

    p_spied.deberia haber_recibido(:viejo).con_argumentos
  end
end

class SuiteSer
  def testear_que_2_deberia_ser_2
    2.deberia ser 2
  end

  def testear_que_2_deberia_ser_igual_2
    2.deberia ser_igual 2
  end
end
TADsPec.testear