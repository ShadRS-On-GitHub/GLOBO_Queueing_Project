#Agent.rb
# A module for the methods of how an Agent ask for and handles clients
# @author = Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems
require 'socket'
require 'json'

# Locally defined files/classes/modules
require_relative '../Client/clientCommunications.rb'
require_relative '../Client/client.rb'
#---------------------------------------------------------------------------
class Agent

  #Create a JSON message and send it to the socket and await a response
  # @param socket [in] A socket that will be used to send/recieve messages
  # @return Either a ClientCommunication or a Client
  def self.send_client_request(socket)

    client_message = ClientCommunication.new(ClientCommunication::request_client)

    #????
    puts "Agent::send_client_request"
    #????

    #Ask for a client to handle
    socket.send( client_message.to_json, 0 )

    #????
    puts "Agent:Message printed to socket:" + client_message.to_json + "|"
    #????

    #Get the response message
    handler_response = JSON.parse(socket.recv(1024), create_additions: true )

    #????
    puts "Agent:Recieved client response"
    #????

    #How to do timeout here?
    #????
    return handler_response
  end #End send_client_request

  # Work with the client, actually just waiting
  # @param client [in] The Client to be processed
  def self.process_client( client )
    sleep( client.time_to_handle )
  end

    # Work with the client, actually just waiting
    # @param client [in] The Client to be processed
    # @return If the parent should shutdown (true/false)
    def self.process_message( msg )
      case msg.message_body
      when ClientCommunication::no_clients_available
        #Nothing to do
        puts "INFO - No Clients available for this agent"

      when ClientCommunication::begin_shutdown
        #Agent's cue to shutdown
        puts "INFO - Recieved SHUTDOWN message"
        return true
      else
        #Report unsuported message type
        puts "WARNING! - Recieved a message of an unsupported type " + msg.message_body
      end

      return false
    end
end #end class Agent
