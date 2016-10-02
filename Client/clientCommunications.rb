#clientCommunications.rb
# A container for messages being transmitted between the Agent and
# the Client Handler
# @author = Shad Scarboro
#---------------------------------------------------------------------------
require "json"
require "socket"

#---------------------------------------------------------------------------

class ClientCommunication

  # Basic initialization method
  # @param message_body [in] The Message to be delivered
  def initialize(message_body)
    @message_body = message_body
  end

  # Basic attribute readers
  attr_reader :message_body

  #---------------------------------------------------------------------------
  # Basic Message Types
  #---------------------------------------------------------------------------

  def self.request_client
    "REQUEST_CLIENT"
  end

  def self.no_clients_available
    "NO_CLIENTS_WAITING"
  end

    def self.begin_shutdown
      "BEGIN_SHUTDOWN"
    end

  #---------------------------------------------------------------------------
  # Other methods
  #---------------------------------------------------------------------------

  # The TCP port used for ClientCommunication
  # Should really be dynamic and not hard coded
  def self.port
    return 181
  end

  #---------------------------------------------------------------------------
  # JSON Related methods
  #---------------------------------------------------------------------------
  #Turn into json for transmission
  #necessary for the JSON automatic serialization
  def to_json(*msg)
    {
      'json_class' => self.class.name,
      'message' => @message_body
    }.to_json(*msg)
  end

  #Create from json
  #necessary for the JSON automatic deserialization
  def self.json_create(msg)
    new(*msg['message'])
  end

end #end class ClientCommunication
