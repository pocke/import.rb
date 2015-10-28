require 'pathname'

# @param [String] path Base path
# @param [String] fname file name
# @return [String|nil]
exist_file = -> (path, fname = nil) {
  pn = Pathname.new(path)
  pn = pn.join(fname) if fname

  full_path = pn.to_s

  return full_path if FileTest.file?(full_path)

  rb ="#{full_path}.rb"
  return rb if FileTest.file?(rb)

  return nil
}

# @param [String] feature
# @return [Pathname|nil]
find_file = -> (feature) {
  # TODO: relative path

  if feature[0] == '/'
    full_path = exist_file.(feature)
    return full_path if full_path
  end

  $LOAD_PATH.each do |path|
    full_path = exist_file.(path, feature)
    return full_path if full_path
  end

  return nil
}

# @param [String] path
# @return [Module]
evaluate = -> (path) {
  script = File.read(path)

  res = Module.new
  res.module_eval(script, path)

  return res
}

define_method(:import, -> (feature) {
  path = find_file.(feature)
  raise LoadError, "cannot load such file -- #{feature}" unless path

  return evaluate.(path)
})
