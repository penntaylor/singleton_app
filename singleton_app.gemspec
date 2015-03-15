Gem::Specification.new do |s|
  s.name        = 'singleton_app'
  s.version     = '0.1.0'
  s.date        = '2015-03-14'
  s.summary     = "Socket-based singleton application class"
  s.description = <<-END
    singleton_app turns an application into a
    singleton application which only allows one copy of itself to be
    running. The class enforces singleness by binding either a named Unix socket
    or a TCP socket. This eliminates some of the platform-specific hassles of
    process lock files, and also provides an easy means for subsequent invocations
    of the application to pass commandline arguments or other data to the running
    singleton.
  END
  s.author      = "Penn Taylor"
  s.email       = 'rpenn3@gmail.com'
  s.files       =  ['lib/singleton_app.rb',
                    'README.md']
  s.homepage    = 'https://github.com/penntaylor/singleton_app'
  s.license     = 'MIT'
end
