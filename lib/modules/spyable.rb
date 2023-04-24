require_relative '../classes/config'
require_relative '../utils/global'

class Config
  def veces(times)
    prok = proc { |spied|
      method_info = call(spied)
      times_called = method_info[:times_called]

      times_called == times
    }
    reason = $failed_matcher_template[:veces].call(self, times)
    Config.new(prok, reason)
  end

  def con_argumentos(*args)
    prok = proc { |spied|
      method_info = call(spied)
      args_used = method_info[:args_used]

      args_used.include? args
    }
    reason = $failed_matcher_template[:con_argumentos].call(self, args)
    Config.new(prok, reason)
  end
end

module Spyable
  def haber_recibido(method)
    prok = proc { |spied| spied.methods_call_map[method] }
    reason = $failed_matcher_template[:haber_recibido].call(self, method)
    Config.new(prok, reason)
  end

  def espiar(obj)
    increment_method_call_count_proc = proc { |a_met|
      @methods_call_map ||= {}
      @methods_call_map[a_met] ||= {}
      @methods_call_map[a_met][:name] ||= a_met
      @methods_call_map[a_met][:times_called] ||= 0
      @methods_call_map[a_met][:times_called] += 1
    }

    add_args_used_proc = proc { |a_met, args|
      @methods_call_map ||= {}
      @methods_call_map[a_met] ||= {}
      @methods_call_map[a_met][:name] ||= a_met
      @methods_call_map[a_met][:args_used] ||= []
      @methods_call_map[a_met][:args_used] << args
    }

    method_missing_proc = proc do |method, *args, &block|
      spied_method = :"spied_#{method}"
      if methods.include? spied_method

        send(:increment_method_call_count, method)
        send(:add_args_used, method, args)
        send(spied_method, *args, &block)
      else
        super(method, *args, &block)
      end
    end

    klass = obj.class
    spied_obj = obj.clone

    klass.instance_methods(false).each do |method|
      unbound_method = klass.send(:instance_method, method)
      spied_obj.send(:define_singleton_method, :"spied_#{method}", unbound_method)
      spied_obj.instance_eval("undef :#{method}", __FILE__, __LINE__)
    end

    spied_obj.send(:define_singleton_method, :increment_method_call_count, increment_method_call_count_proc)
    spied_obj.send(:define_singleton_method, :add_args_used, add_args_used_proc)
    spied_obj.send(:define_singleton_method, :method_missing, method_missing_proc)
    spied_obj.send(:define_singleton_method, :methods_call_map, proc { @methods_call_map })

    spied_obj
  end
end
