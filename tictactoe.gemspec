Gem::Specification.new do |s|
  s.name = "tictactoe-randall"  # i.e. visualruby.  This name will show up in the gem list.
  s.version = "0.0.3"  # i.e. (major,non-backwards compatable).(backwards compatable).(bugfix)
	s.add_dependency "vrlib", ">= 0.0.1"
	s.add_dependency "gtk2", ">= 0.0.1"
	s.add_dependency "require_all", ">= 0.0.1"
	s.licenses = ['MIT']
	s.has_rdoc = false
  s.authors = ["Randall Reed"] 
  s.summary = "GUI Tic Tac Toe game." # optional
	s.executables = ['tictactoe']  # i.e. 'vr' (optional, blank if library project)
	s.default_executable = 'tictactoe'  # i.e. 'vr' (optional, blank if library project)
	s.bindir = ['.']    # optional, default = bin
	s.require_paths = ['.']  # optional, default = lib 
	s.files = Dir.glob(File.join("**", "*.{rb,glade,jpg}"))
	s.rubyforge_project = "nowarning" # supress warning message 
end
