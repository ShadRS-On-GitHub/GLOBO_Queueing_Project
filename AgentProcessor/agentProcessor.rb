#agentProcessor.rb
# Asks for Clients of the Client Queues it has connected to
# @author = Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems
require 'socket'
require 'json'

# Locally defined files/classes/modules
require_relative '../Client/clientCommunications.rb'
require_relative '../AgentProcessor/agent.rb'

#---------------------------------------------------------------------------
#Connect with a Client Queue
#---------------------------------------------------------------------------
#An actual Agent's client would allow this to be specified
queue_name = 'localhost'


#If socket creation failed exit
#????

#Send authentication
#????

#Set up timing for time outs
time_out = 180 #If we haven't heard anything for 180 seconds, exit
last_time = Time.now

loop do
  #Open out socket
  socket = TCPSocket.open(queue_name,ClientCommunication::port)

  #Request a new client
  handler_response = Agent::send_client_request( socket )

  #Check the response and handle appropriatly
  case handler_response.class.name
  when ClientCommunication.name #Handle the message
    client_shutdown = Agent::process_message(handler_response)

    # If told to shutdown, break out of the loop
    break if client_shutdown

    last_time = Time.now #Update that we know the server still exists

  when Client.name #Handle the Client
    Agent::process_client(handler_response)
    last_time = Time.now #Update that we know the server still exists

  else
    #Report Error
    puts "WARNING! - Recieved a response of an unsupported type " + handler_response.class.name
  end

  #Check for timeout condition
  break if (Time.now - last_time) > time_out
end

#????
puts "AgentProcessor - Exiting"
#????
