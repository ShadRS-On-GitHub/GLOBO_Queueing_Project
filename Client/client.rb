#client.rb
# A simple container class to store the basic client information
# @author = Shad Scarboro
#---------------------------------------------------------------------------
require "json"

class Client
  # Basic initialization method
  # @param caller_id [in] The unique ID of the Client
  # @param time_in [in] The time since initialization (in seconds) when the client should be added to the queue
  # @param time_to_handle [in] How long (in seconds) it will take an agent to process this Client
  def initialize(caller_id, time_in, time_to_handle)
    @caller_id = caller_id
    @time_in = time_in
    @time_to_handle = time_to_handle
  end

  # Basic attribute readers
  attr_reader :caller_id
  attr_reader :time_in
  attr_reader :time_to_handle

  #Turn into json for transmission
  def to_json(*client)
    {
      'json_class' => self.class.name,
      'data' => [ caller_id, time_in, time_to_handle]
    }.to_json(*client)
  end

  #Create from json
  def self.json_create(client)
    new(*client['data'])
  end

end #End Class Client
