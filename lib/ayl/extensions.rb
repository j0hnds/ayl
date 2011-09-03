module Ayl

  module Extensions

    def ayl_send(selector, *args)
      ayl_send_opts(selector, {}, args)
    end

    def ayl_send_opts(selector, opts, *args)
      puts "## ayl_send_opts(#{selector.inspect}, #{opts.inspect}, #{args.inspect})"
    end

  end

end
