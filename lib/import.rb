require 'pathname'

module Import
  class << self
    # If file exists, returns full path. unless, returns nil
    # @param [String] path Base path
    # @param [String] fname file name
    # @return [String|nil]
    def exist_file(path, fname = nil)
      pn = Pathname.new(path)
      pn = pn.join(fname) if fname

      full_path = pn.to_s

      return full_path if FileTest.file?(full_path)

      rb ="#{full_path}.rb"
      return rb if FileTest.file?(rb)

      return nil
    end

    # @param [String] feature
    # @return [String|nil]
    def find_file(feature, base)
      # absolute path
      if feature[0] == '/'
        full_path = exist_file(feature)
        return full_path if full_path
      end

      # relative path
      if feature.start_with?('./') || feature.start_with?('../')
        full_path = exist_file(File.expand_path("../#{feature}", base))
        return full_path if full_path
      end

      $LOAD_PATH.each do |path|
        full_path = exist_file(path, feature)
        return full_path if full_path
      end

      return nil
    end

    # @param [String] path
    # @return [Module]
    def evaluate(path)
      script = File.read(path)

      res = Module.new
      res.module_eval(script, path)

      return res
    end

    # @param [String] feature
    # @param [String] base
    def import(feature, base = caller_locations[0].absolute_path)
      path = find_file(feature, base)
      raise LoadError, "cannot load such file -- #{feature}" unless path

      return evaluate(path)
    end

    define_method(:global) do
      module ::Kernel
        def import(feature)
          Import.import(feature, caller_locations[0].absolute_path)
        end
      end
    end
  end
end
