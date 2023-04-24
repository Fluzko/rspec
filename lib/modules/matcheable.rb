require_relative '../utils/global'
require_relative '../classes/config'

module Matcheable
  def ser_igual(val)
    prok = proc { |x| x == val }
    template = $failed_matcher_template[:ser].call(val)
    Config.new(prok, template)
  end

  def ser(val)
    return ser_igual(val) unless val.is_a? Config

    val
  end

  def mayor_a(val)
    prok = proc { |x| x > val }
    template = $failed_matcher_template[:mayor_a].call(val)
    Config.new(prok, template)
  end

  def polimorfico_con(val)
    prok = proc { |x| val.instance_methods.all? { |m| x.respond_to? m } }
    template = $failed_matcher_template[:polimorfico_con].call(val)
    Config.new(prok, template)
  end

  def menor_a(val)
    prok = proc { |x| x < val }
    template = $failed_matcher_template[:menor_a].call(val)
    Config.new(prok, template)
  end

  def entender(msg)
    prok = proc { |x| x.respond_to? msg }
    template = $failed_matcher_template[:entender].call(val)
    Config.new(prok, template)
  end

  def uno_de_estos(*args)
    template_proc = $failed_matcher_template[:uno_de_estos]

    prok = proc { |x| args.include? x }
    return Config.new(prok, template_proc.call(args)) if args.length > 1

    prok = proc { |x| args[0].include? x }
    Config.new(prok, template_proc.call(args[0]))
  end

  def explotar_con(exception)
    prok = proc { |block|
      begin
        block.call
        false
      rescue exception
        true
      rescue StandardError
        false
      end
    }
    template = $failed_matcher_template[:explotar_con].call(exception)
    Config.new(prok, template)
  end

  def deberia(matcher)
    matcher.call(self) or raise MatcherFailedException.new(matcher.string_proc, self)
  end

  def respond_to_missing?(method, include_private = false)
    [$tener_prefix, $ser_prefix].any? { |prefix| method.to_s.start_with? prefix } || super
  end

  def method_missing(m, *args, &block)
    method_prefix = [$ser_prefix, $tener_prefix].find { |prefix| m.to_s.start_with? prefix }

    if method_prefix
      method_name = "#{m.to_s.sub! method_prefix, ''}#{'?' if method_prefix == 'ser_'}"
      ser_template = $failed_matcher_template[:ser_generic].call(method_name)
      ser_prok = proc { |x| x.send(method_name, *args) }
      return Config.new(ser_prok, ser_template) if method_prefix == 'ser_'

      unless args[0].is_a? Config
        tener_prok = proc { |x| x.send(method_name) == args[0] }
        return Config.new(tener_prok, $failed_matcher_template[:tener_generic].call(method_name))
      end

      # TODO: revisar cual es este caso
      a_proc = args[0]
      return Config.new(proc { |x| a_proc.call(x.send(method_name)) }, '')
    end

    super
  end
end
