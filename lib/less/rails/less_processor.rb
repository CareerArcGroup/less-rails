module Less
  module Rails
    class LessProcessor
      def initilize(filename, &block)
        @filename = filename
        @source   = block.call
      end

      # Sprockets 2.x interface
      def render(context, _)
        self.class.process(@filename, @source, context)
      end

      # Sprockets 3.x+ interface
      def self.call(input)
        filename = input[:filename]
        source   = input[:data]
        context  = input[:environment].context_class.new(input)

        result = process(filename, source, context)
        context.metadata.merge(data: result)
      end

      # process less files using tilt template
      def self.process(filename, source, context)
        template = LessTemplate.new(filename) { source }
        template.render(context, {})
      end
    end
  end
end