module Ayl

  class Railtie < ::Rails::Railtie

    # The hooks to be created/installed on ActiveRecord::Base
    HOOKS = [ :after_update, :after_create, :after_save ]

    initializer "Ayl::Railtie.extend" do
      ActiveRecord::Base.send :include, Extensions
    end

    initializer "Ayl::Railtie.hooks" do

      class << ActiveRecord::Base

        # Add each of the hooks to ActiveRecord::Base
        HOOKS.each do | hook |
          code = %Q{def ayl_#{hook}(*methods, &b) add_ayl_hook(#{hook.inspect}, *methods, &b) end}
          class_eval(code, __FILE__, __LINE__ - 1)
        end

        def add_ayl_hook(hook, *args, &block)
          if args && args.first.is_a?(Symbol)
            method = args.shift
            ayl_hooks[hook] << lambda{|o| o.send(method)}
          else
            ayl_hooks[hook] << block
          end
        end

        def ayl_hooks
          @ayn_hooks ||= Hash.new do |hash, hook|
            ahook = "_ayl_#{hook}".to_sym
            
            # This is for the producer's benefit
            send(hook) { |o| ayl_send(ahook, o) }

            # This is for the worker's benefit
            code = %Q{def #{ahook}(o) run_ayl_hooks(#{hook.inspect}, o) end}
            instance_eval(code, __FILE__, __LINE__ - 1)

            hash[hook] = []
          end
        end

        def run_ayl_hooks(hook, o)
          ayl_hooks[hook].each { |b| b.call(o) }
        end

      end
      
    end

  end

end
