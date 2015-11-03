require 'pathname'

module Import
  require_relative 'import/namespace'

  class << self
    # @param [String] feature
    # @param [String] base
    def import(feature, base = caller_locations[0].absolute_path)
      path = find_file(feature, base)
      raise LoadError, "cannot load such file -- #{feature}" unless path

      return evaluate(path)
    end

    # @param [String] feature
    def import_relative(feature)
      return import("./#{feature}", caller_locations[0].absolute_path)
    end

    def global
      ::Kernel.__send__(:define_method, :import, -> (feature) {
        Import.import(feature, caller_locations[0].absolute_path)
      })
    end


    private

    # If file exists, returns full path. unless, returns nil
    # @param [String] path Base path
    # @param [String] fname file name
    # @return [String|nil]
    def exist_file(path, fname = nil)
      pn = Pathname.new(path)
      pn = pn.join(fname) if fname

      full_path = pn.to_s

      return full_path if FileTest.file?(full_path)

      rb = "#{full_path}.rb"
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
    # @param [Module] namespace
    # @return [Module]
    def evaluate(path, namespace = nil)
      script = File.read(path)

      res = namespace || Namespace.new
      with_replace_require(res) do
        res.module_eval(script, path)
      end

      return res
    end

    # @param [Module] mod
    # @param [Proc] block
    def with_replace_require(mod, &block)
      orig = ::Kernel.instance_method(:require)

      this = self
      ::Kernel.__send__(:define_method, :require, -> (feature) {
        full_path = this.__send__(:find_file, feature, caller_locations[0].absolute_path)
        if full_path
          return false if mod.required?(full_path)
          mod.required << full_path
          this.__send__(:evaluate, full_path, mod)
        else
          orig.bind(nil).call(feature)
        end
      })

      block && block.call
    ensure
      ::Kernel.__send__(:define_method, :require, orig)
    end

  end

  VERSION = self.import('./import/version')::VERSION
end
