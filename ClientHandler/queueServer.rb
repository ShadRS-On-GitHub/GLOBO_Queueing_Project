#queueServer.rb
# Handles all server interactions necessary for the Client Queue
# @author = Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems
require 'socket'
require 'json'

# Locally defined files/classes/modules
require_relative 'clientPipeline.rb'
require_relative 'clientQueue.rb'

#---------------------------------------------------------------------------
class QueueServer < ClientPipeline

    # Basic initialization method
    # @param queue_cost [in] A client's cost for using this queue
    # @param port [in] The port the TCP server will be opened on
    def initialize(queue_cost, port)
      super(queue_cost)
      #Start the server and start listening
      @q_server = TCPServer.open(port)
    end

    #---------------------------------------------------------------------------

    # Execute the master messaging loop
    def begin_client_monitoring
      super()

      Socket.accept_loop(@q_server) do |contact|
          #puts "SERVER: Server recieved connection"
          begin
            communication = contact.recv(1024)
            #puts "SERVER: Server recieved message: #{communication}"

            process_communication( communication, contact )

          rescue Exception => exp
            puts "#{ exp } (#{ exp.class })"
          ensure
            #Close the Socket
            contact.close
          end

        break if ClientQueue.instance.queue_completed
      end #end Socket.accept_loop(server) do |contact|

    end #end def listenLoop

    #---------------------------------------------------------------------------

    # Processes the recieved communication into a JSON message
    # @param communication [in] The message recieved from the socket
    # @param contact [out] The socket so that the processing can send responses
    # @return boolean, true if the master socket handling loop should exit
    # @param communication [in] The communication to be processed
    # @param contact [out] The socket so that the processing can send responses
    def process_communication ( communication, contact )

      if communication.length >= 2
        communication = JSON.parse( communication, create_additions: true )

        if communication.class.name == ClientCommunication.name
          #process_message
          process_message(communication, contact)
        else
          #Bad Communication
          puts "SERVER: ERROR! - Bad message from AgentProcessor - " + communication.class.name
        end #end if communication.class.name
      end
    end #end process_communication ( communication, contact )

    #---------------------------------------------------------------------------

    # Processes the JSON message and returns the appropriate response
    # @param msg [in] The JSON message to be processed
    # @param contact [out] The socket so that the processing can send responses
    def process_message ( msg, contact )
      case msg.message_body
        when ClientCommunication::request_client
          next_client = ClientQueue.instance.shift(@queue_cost)

          #Convert to JSON
          json_message = create_out_message (next_client)

          #Send the message
          contact.send(json_message, 0)
        else
          puts "ERROR! - Unsupported message type - " + msg.message_body
        end #End case msg.message_body

    end # end process_message ( communication, contact )

    # Create a JSON response message.  Either a client or another message
    # @param next_client [in] The next client to be Sent
    # @return A JSON formatted message
    def create_out_message ( next_client )
      out_message = nil
      #If the next client is valid, send it along
      if next_client != nil
        out_message = next_client

      #Check if the Queue has completed all of its processing for the day
    elsif ClientQueue.instance.queue_completed
        out_message = ClientCommunication.new(ClientCommunication::begin_shutdown)

      #Else return a NO_CLIENTS_WAITING message
      else
        out_message = ClientCommunication.new(ClientCommunication::no_clients_available)
      end
      return out_message.to_json
    end #end create_out_message
  end #end Class QueueServer
