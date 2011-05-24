class GemPackage
  
  attr_reader :name, :version, :files
  
  def initialize
    @name = 'eymiha_math3'
    @version = '1.0.2'
    @files = FileList[
      '*.rb',
      'lib/**/*',
      'test/*',
      'html/**/*'
    ]
  end

  def fill_spec(s)
    s.name = name
    s.version = version
    s.summary = "Emiyha - basic 3D math extensions"
    s.files = files.to_a
    s.require_path = 'lib'
    s.has_rdoc = true
    s.rdoc_options << "--all"
    s.author = "Dave Anderson"
    s.email = "dave@eymiha.com"
    s.homepage = "http://www.eymiha.com"
    s.rubyforge_project = "cori"
    s.add_dependency("eymiha",">= 1.0.0")
    s.add_dependency("eymiha_math",">= 1.0.0")
  end

end
