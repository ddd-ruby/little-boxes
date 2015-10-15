require 'little_boxes/remarkable_inspect'

module LittleBoxes
  class ConfigBase
    include RemarkableInspect

    def [](key)
      public_send key
    end

    def []=(key, value)
      public_send "#{key}=", value
    end

    def remarkable_methods
      keys
    end

    def keys
      self.class.keys
    end

    private

    def procs
      self.class.procs
    end

    def get name
      instance_variable_get("@#{name}")
    end

    def set name, value
      instance_variable_set("@#{name}", value)
    end

    def get_from_proc name
      procs[name] && procs[name].call
    end

    class << self
      def attr name
        name = name.to_sym

        attr_writer name

        keys << name

        define_method name do |&block|
          if block
            procs[name] = block
          else
            get(name) || set(name, get_from_proc(name))
          end
        end
      end

      def keys
        @keys ||= []
      end

      def procs
        @procs ||= {}
      end
    end
  end
end
