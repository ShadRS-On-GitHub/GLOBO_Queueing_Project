#clientOperator.rb
#
# @author Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems


# Locally defined files/classes/modules

#---------------------------------------------------------------------------

class ClientOperator

  #---------------------------------------------------------------------------
  # Basic initialization method
  def initialize
    #Read in the CSV file
  end

  #---------------------------------------------------------------------------
  # Basic attribute accessors

  #---------------------------------------------------------------------------


  #---------------------------------------------------------------------------
  # Begin the recieve loop
  def recieve_clients
    #Wait unitil the timing has started
    sleep(1) until ClientQueue.timing_started

    #Add dummy items for testing
    ClientQueue.push ( Client.new (0,0,5))
    ClientQueue.push ( Client.new (1,0,6))
    sleep(4)
    ClientQueue.push ( Client.new (2,4,5))
    sleep(1)
    ClientQueue.push ( Client.new (2,5,2))

  end #end recieve_clients

  #---------------------------------------------------------------------------

end #end class ClientOperator
