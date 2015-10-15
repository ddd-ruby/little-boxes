module LittleBoxes
  module RemarkableInspect
    def inspect
      RemarkableInspect.for self
    end

    def remarkable_methods
      methods(false) + 
        self.class.instance_methods(false) - 
        [:inspect, :remarkable_methods]
    end

    class << self
      def for(obj)
        "#<#{obj.class}:0x#{hex_id_for obj} #{methods_list_for(obj)}>"
      end

      def hex_id_for(obj)
        '%x' % (obj.object_id << 1)
      end

      # Substittues [my_method, my_method=] by [my_method/=]
      def compact_getsetters(methods)
        methods.sort.map(&:to_s).tap do |mm|
          mm.grep(/\=$/).each do |setter|
            getter = setter.gsub(/\=$/, '')

            if mm.include? getter
              mm.delete setter
              mm[mm.find_index(getter)] = setter.gsub(/\=$/, '/=')
            end
          end
        end
      end

      def methods_list_for(obj)
        compact_getsetters(obj.remarkable_methods).join(", ")
      end
    end
  end
end