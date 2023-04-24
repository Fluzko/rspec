$test_state_map = {
  pass: 'Pass',
  failed: 'Fail',
  exception: 'Exception'
}

$test_method_prefix = 'testear_que_'

$ser_prefix = "ser_"

$tener_prefix = "tener_"

$failed_matcher_template = {
  ser: proc { |val| "{x} == #{val}" },
  mayor_a: proc { |val| "{x} > #{val}" },
  menor_a: proc { |val| "{x} < #{val}" },
  polimorfico_con: proc { |val| "{x} polimorfico con #{val}" },
  entender: proc { |msg| "{x} entienda #{msg}" },
  uno_de_estos: proc { |args| "{x} contenga #{args}" },
  explotar_con: proc { |exception| "explotar con #{exception}" },
  ser_generic: proc { |method_name| "{x} sea #{method_name}" },
  tener_generic: proc { |method_name| "{x} tenga #{method_name}" },
  veces: proc { |method, times| "que #{method} haya sido llamado #{times} veces" },
  con_argumentos: proc { |method, args| "que #{method} haya sido llamado con los argumentos #{args}" },
  haber_recibido: proc { |obj, method| "que #{obj} haya recibido #{method}" }
}
