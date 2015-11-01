class Import::Namespace < Module 
  attr_reader :required

  def initialize
    @required = []
    super
  end

  # @param [String] file an absolute path
  # @return [Boolean]
  def required?(file)
    @required.include?(file)
  end
end
