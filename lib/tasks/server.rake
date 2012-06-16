
require 'rubygems'
require 'eventmachine'

task :run_server => :environment  do

EM.run do 
  EM.add_periodic_timer(1){puts "Tick..."}
  EM.add_timer(3) do
      puts 'waited 3 sec'
      EM.stop_event_loop
  end
end
end

task :s1 do

  module Server
     def receive_data(data)
         puts data
         send_data("hello\n")
     end
  end
  EM.run{EM.start_server 'localhost',8080,Server}
end
