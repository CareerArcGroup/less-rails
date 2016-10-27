module Less
  module Rails
    class ImportProcessor
      IMPORT_SCANNER = /@import\s*['"]([^'"]+)['"]\s*;/.freeze

      def initilize(filename, &block)
        @filename = filename
        @source   = block.call
      end

      # Sprockets 2.x interface
      def render(context, _)
        self.class.depend_on(context, @source)
      end

      # Sprockets 3.x+ interface
      def self.call(input)
        filename = input[:filename]
        source   = input[:data]
        context  = input[:environment].context_class.new(input)

        result = depend_on(context, source)
        context.metadata.merge(data: result)
      end

      # Read less files looking for import directives and
      # cause imported files to be a dependency
      def self.depend_on(context, source, base=File.dirname(context.logical_path))
        import_paths = source.scan(IMPORT_SCANNER).flatten.compact.uniq
        import_paths.each do |path|
          if path = resolve_path(context, path) || resolve_path(context, File.join(base, path))
            context.depend_on(path) if path.to_s.ends_with?(".less")
            depend_on context, File.read(path), File.dirname(path)
          end
        end
        source
      end

      # attempt to resolve the given path
      def self.resolve_path(context, path)
        begin
          context.resolve(path)
        rescue Sprockets::FileNotFound
          nil
        end
      end
    end
  end
end