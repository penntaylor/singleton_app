singleton_app
=============

Socket-based singleton application class in Ruby.

singleton_app provides the class SingletonApp, which represents a 
singleton application that only allows one copy of itself to be
running. The class enforces singleness by binding either a named Unix socket 
or a TCP socket. This eliminates some of the platform-specific hassles of
process lock files, and also provides an easy means for subsequent invocations
of the application to pass commandline arguments or other data to the running
singleton.

To use it in its simplest form, inherit from SingletonApp and override the
method `#start_application`.

Basic Example:
--------------

    ----
    require './singleton_app'
        
    class MyApp < SingletonApp
      def start_application
        20.times do
          puts "MyApp is doing something."
          sleep(1)
        end
      end
    end
     
    # Run the application, Unix-only version
    MyApp.new("/tmp/my_app_socket")

    # Cross-platform version. Notice how the port is specified.
    MyApp.new('127.0.0.1',:port=>5024)
    ----

Data-passing example
--------------------
To allow data to be passed from subsequent invocations back to the singleton,
create the class with the option `:listen=>true` and override the methods
`#send_data_to_singleton` and `#handle_data_from_client` in addition to 
`#start_application`, as in the example below.

When a second instance of this example is run, it sends the string
`'Sending data to singleton'` to the singleton instance. The singleton
instance reads the string and prints it to STDOUT.

    ----
    require './singleton_app'
    
    class MyApp < SingletonApp
      def start_application
        puts "Starting singleton application"
        20.times do
          puts "MyApp is doing something."
          sleep(1)
          # If we were to meet a condition that would cause us to want to
          # exit here, we would call
          #stop_application
        end
      end
    
      def send_data_to_singleton(connection)
        puts "Starting client application"
        connection.puts('Sending data to singleton')
      end
    
      def handle_data_from_client(connection)
        data = connection.read
        # Do something with the data...
        puts "Got: #{data}"
        # And then return either success or failure
        return true
      end
    end
      
    # Run the application, Unix-only version; notice the :listen option
    MyApp.new("/tmp/my_app_socket",:listen=>true)
    # Cross-platform version
    MyApp.new('127.0.0.1',:port=>5024,:listen=>true)
    ----
    
The following table represents two separate terminal sessions running the
above code from the file `myapp.rb`. Time flows from top to bottom
    
        |Terminal 1 (First instance)       | Terminal 2 (Second instance)     |
        |----------------------------------|----------------------------------|
        | $ ruby myapp.rb                  |                                  |
        | Starting singleton application   |                                  |
        | MyApp is doing something.        |                                  |
        | MyApp is doing something.        | $ ruby myapp.rb                  |
        | MyApp is doing something.        | Starting client application      |
        | Got: Sending data to singleton   |                                  |
        | MyApp is doing something.        | #second instance has exited      |
        | MyApp is doing something.        |                                  |
        | MyApp is doing something         |                                  |
        | ...etc...                        |                                  |
        |----------------------------------|----------------------------------|
    