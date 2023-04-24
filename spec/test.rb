require 'rspec'
require_relative '../lib/tadspec'
require_relative 'example'

describe 'Deberia' do
  let(:nico_class) do
    Class.new do
      def edad
        30
      end

      def viejo?
        edad > 29
      end
    end
  end
  let(:tadp_class) do
    Class.new do
      def docentes
        [:nico_class]
      end
    end
  end
  let(:erwin_class) do
    Class.new do
      def nombre
        'erwin'
      end

      def docente
        true
      end

      def edad
        18
      end
    end
  end

  let(:leandro_class) do
    Class.new do
      def edad
        22
      end

      def viejo?
        edad > 29
      end
    end
  end

  class Persona
    def initialize(edad)
      @edad = edad
    end

    def viejo?
      @edad > 29
    end
  end

  class OtraSuite
    def testear_que_x
      puts 'hola'
    end

    def otro_metodo_que_no_es_un_test; end
  end

  class UnaClaseComun
    def metodo_que_no_es_un_test; end
  end

  class PersonaHome
    def todas_las_personas
      # Este método consume un servicio web que consulta una base de datos
    end

    def personas_viejas
      todas_las_personas.select { |p| p.viejo? }
    end
  end

  it 'deberia test' do
    tadp = tadp_class.new
    nico = :nico_class
    expect(tadp.docentes[0].deberia(ser(nico))).to be true
  end
  it 'deberia test 2' do
    erwin = erwin_class.new
    expect(erwin.edad.deberia(ser(menor_a(40)))).to be true
  end

  it 'deberia test 3' do
    erwin = erwin_class.new
    expect(erwin.docente.deberia(ser(true))).to be true
  end

  it 'deberia test 4' do
    erwin = erwin_class.new
    expect(erwin.edad.deberia(ser(18))).to be true
  end

  it 'deberia test 5' do
    expect(7.deberia(ser(7))).to be true
  end

  it 'deberia test 6' do
    expect(true.deberia(ser(false))).to be false
  end

  it 'deberia test 7' do
    leandro = leandro_class.new
    expect(leandro.edad.deberia(ser(25))).to be false
  end

  it 'deberia test 8' do
    leandro = leandro_class.new
    expect(leandro.edad.deberia(ser(mayor_a(20)))).to be true
  end

  it 'deberia test 9' do
    leandro = leandro_class.new
    expect(leandro.edad.deberia(ser(menor_a(25)))).to be true
  end

  it 'deberia test 10' do
    leandro = leandro_class.new
    expect(leandro.edad.deberia(ser(uno_de_estos([7, 22, 'hola'])))).to be true
  end

  it 'deberia test 11' do
    leandro = leandro_class.new
    expect(leandro.edad.deberia(ser(uno_de_estos(7, 22, 'hola')))).to be true
  end

  it 'deberia test 12' do
    nico = nico_class.new
    expect(nico.deberia(ser_viejo)).to be true
  end

  it 'deberia test 13' do
    nico = nico_class.new
    expect(nico.viejo?.deberia(ser(true))).to be true
  end

  it 'deberia test 14' do
    leandro = leandro_class.new
    expect(leandro.deberia(ser_viejo)).to be false
  end

  it 'deberia test 15' do
    leandro = leandro_class.new
    expect { leandro.deberia ser_joven }.to raise_error(NoMethodError)
  end

  it 'deberia test 16' do
    leandro = leandro_class.new
    expect(leandro.deberia(tener_edad(22))).to be true
  end

  it 'deberia test 17' do
    leandro = leandro_class.new
    expect { leandro.deberia tener_nombre 'leandro' }.to raise_error(NoMethodError)
  end
  # it "deberia test 18" do
  # leandro = leandro_class.new
  # expect(leandro.deberia tener_nombre).to be_nil
  # end
  it 'deberia test 19' do
    leandro = leandro_class.new
    expect(leandro.deberia(tener_edad(mayor_a(20)))).to be true
  end

  it 'deberia test 20' do
    leandro = leandro_class.new
    expect(leandro.deberia(tener_edad(menor_a(25)))).to be true
  end

  it 'deberia test 21' do
    leandro = leandro_class.new
    expect(leandro.deberia(tener_edad(uno_de_estos([7, 22, 'hola'])))).to be true
  end

  it 'deberia test 22' do
    leandro = leandro_class.new
    expect(leandro.deberia(entender(:viejo?))).to be true
  end
  it 'deberia test 23' do
    leandro = leandro_class.new
    expect(leandro.deberia(entender(:class))).to be true
  end

  it 'deberia test 24' do
    leandro = leandro_class.new
    expect(leandro.deberia(entender(:nombre))).to be false
  end

  it 'deberia test 25' do
    proc { 7 / 0 }.deberia explotar_con ZeroDivisionError
  end

  it 'deberia test 26' do
    leandro = leandro_class.new
    proc { leandro.nombre }.deberia explotar_con NoMethodError
  end

  it 'deberia test 27' do
    leandro = leandro_class.new
    proc { proc { leandro.viejo? }.deberia explotar_con NoMethodError }.deberia explotar_con StandardError
  end

  it 'deberia test 28' do
    leandro = leandro_class.new
    expect(proc { leandro.viejo? }.deberia(explotar_con(NoMethodError))).to be false
  end

  it 'deberia test 29' do
    expect(proc { 7 / 0 }.deberia(explotar_con(NoMethodError))).to be false
  end

  it 'Verificacion de que suites to test contiene Suite' do
    expect(TADsPec.suites_to_test).to include(Suite)
  end

  it 'Verificacion de que suites to test contiene Suites' do
    suites = TADsPec.suites_to_test
    expect(suites).to include(Suite)
    expect(suites).to include(OtraSuite)
  end

  it 'Verificacion Clase comun no es suite' do
    suites = TADsPec.suites_to_test(UnaClaseComun)
    expect(suites).to eq([])
  end

  it 'Verificacion suite' do
    suites = TADsPec.suites_to_test(Suite)
    expect(suites).to eq([Suite])
  end

  it 'Verificacion suite 2' do
    suites = TADsPec.suites_to_test(Suite, :pasa_algo)
    expect(suites).to eq([Suite])
  end

  it 'Verificacion suite 3' do
    suites = TADsPec.suites_to_test(Suite, :pepe)
    expect(suites).to eq([])
  end

  it 'Correr suite' do
    suite = TADsPec.suites_to_test(Suite)
    wrappedTestSuite = WrappedSuite.new(suite.first)
    wrappedTestSuite.run
  end

  it 'Correr suites' do
    TADsPec.run_test([Suite])
  end
end

describe 'Mocks' do
  class PersonaHome
    def todas_las_personas
      # Este método consume un servicio web que consulta una base de datos
    end

    def personas_viejas
      todas_las_personas.select { |p| p.viejo? }
    end
  end
  TracePoint

  class PersonaHomeTests
    def testear_que_personas_viejas_trae_solo_a_los_viejos
      nico = Persona.new(30)
      axel = Persona.new(30)
      lean = Persona.new(22)

      # Mockeo el mensaje para no consumir el servicio y simplificar el test
      PersonaHome.mockear(:todas_las_personas) do
        [nico, axel, lean]
      end

      viejos = PersonaHome.personas_viejas

      viejos.deberia ser [nico, axel]
    end
  end
  it 'Mock test' do
    TADsPec.testear PersonaHomeTests
  end
end
