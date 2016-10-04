#testing_AgentProcessor.rb
# Tests the agentProcessor
# Should use an actual testing framework
# @author = Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems
require 'socket'
require 'json'

# Locally defined files/classes/modules
require_relative '../Client/clientCommunications.rb'
require_relative '../Client/client.rb'

$request_count = 0

def running_thread_count
  Thread.list.select {|thread| thread.status == "run"}.count
end

def test_process_message( msg, socket )

  puts "SERVER: test_process_message: " + msg.message_body

  case msg.message_body
  when ClientCommunication::request_client
    puts "SERVER: case of " + ClientCommunication::request_client
    puts "SERVER: Count is at #{$request_count}"

    case $request_count
    when 0
      #First time, send a Client
      $request_count = 1
      puts "SERVER: Sending a Client to the Agent"

      #Send back a client
      test_client = Client.new(0,1,3)
      puts "SERVER: -Client was created"

      socket.send(test_client.to_json, 0)
      puts "SERVER: -Client was Sent"
    when 1
      #Second time, return No Client
      $request_count = 2
      out_message = ClientCommunication.new(ClientCommunication::no_clients_available)
      socket.send(out_message.to_json, 0)
    else
      #Third Time (and more), Send Terminate
      out_message = ClientCommunication.new(ClientCommunication::begin_shutdown)
      socket.send(out_message.to_json, 0)
      $request_count = 3
      puts "SERVER: Sent Shutdown message to AgentProcessor"

    end #End case request_count
  else
    puts "ERROR! - Bad message type - " + msg.message_body
  end #End case msg.message_body
end

#---------------------------------------------------------------------------
#initialization of the service
# Create TCP server
server = TCPServer.new(ClientCommunication::port)

puts "SERVER: Server Open"

#Launch the AgentProcessor
apThread = Thread.new {
  system( "cd ../AgentProcessor; ruby agentProcessor.rb")
}

#---------------------------------------------------------------------------
last_time = Time.now

# Wait for a connection
Socket.accept_loop(server) do |agt|
    puts "SERVER: Server recieved connection"
    begin
      response = agt.recv(1024)
      puts "SERVER: Server recieved message: " + response

      message = nil
      if response.length >= 2
        message = JSON.parse( response, create_additions: true )
        puts "SERVER: Message parsed into JSON: #{message.class.name}"
      else
        #Ignore and go to the next cycle
        next
      end

      case message.class.name
      when ClientCommunication.name
        #process_message
        puts "SERVER: Processing Client Message"
        test_process_message(message, agt)
        puts "SERVER: Elapsed #{Time.now - last_time} "
        last_time = Time.now
      else
        #Bad Communication
        puts "SERVER: ERROR! - Bad message from AgentProcessor - " + message.class.name

        Thread.current.terminate
      end #end case message.class.name
    rescue Exception => exp
      puts "#{ exp } (#{ exp.class })"
    ensure
      #Close the Socket
      agt.close
    end

  puts "SERVER: -------------------"
  puts "SERVER: Main loop: #{$request_count}"
  puts "SERVER: Thread count #{running_thread_count}"
  puts "SERVER: +++++++++++++++++++"

  break if $request_count >= 3
end #end Socket.accept_loop(server) do |agt|

puts "SERVER: After main loop"

#Close down threads
Thread.kill(apThread)
