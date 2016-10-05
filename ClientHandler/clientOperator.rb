#clientOperator.rb
# Reads in a CSV file and adds the Clients there in to the queue
#  at the appropriate time
# @author Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems
require 'csv'

# Locally defined files/classes/modules
require_relative 'clientQueue.rb'
require_relative '../Client/client.rb'

#---------------------------------------------------------------------------

class ClientOperator

  #---------------------------------------------------------------------------
  # Basic initialization method
  # @param path_to_file [in] A path to a CSV file that holds the client information
  def initialize (path_to_file)
    #Read in the CSV file
    @all_clients = CSV.read(path_to_file, converters: :numeric)
    @all_clients.shift #remove the header
    #???? TODO: Add CSV file data validation
  end

  #---------------------------------------------------------------------------
  # Begin the recieve loop
  def recieve_clients
    #Wait unitil the timing has started
    sleep(1) until ClientQueue.instance.timing_started

    #Keep going until all clients have been added to the queue
    while @all_clients.length > 0 && ! ClientQueue.instance.queue_completed
      next_add_at = ClientQueue.instance.start_time + @all_clients[0][1]

      #Passed the time to add the client, add it now
      if( Time.now > next_add_at)
        add_client()
      else
        #Wait until it is time, then add client
        sleep( next_add_at - Time.now )
        add_client()
      end

    end #end while @all_clients.length > 0

    #Let the ClientQueue know it will not be recieving any more Clients
    ClientQueue.instance.queue_completed = true
  end #end recieve_clients

  #---------------------------------------------------------------------------
  # Add the top client to the ClientQueue and remove it from the list
  def add_client
    ClientQueue.instance.push(Client.new(@all_clients[0][0],
                                @all_clients[0][1],
                                @all_clients[0][2]) )
    @all_clients.shift
  end

  #---------------------------------------------------------------------------
end #end class ClientOperator
