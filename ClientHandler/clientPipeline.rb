#clientPipeline.rb
# Monitors the client queue and requests items from that queue, logging the activity
# waiting too long
# @author Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems


# Locally defined files/classes/modules
require_relative 'clientQueue.rb'

#---------------------------------------------------------------------------

class ClientPipeline
    # Basic initialization method
    # @param queue_cost [in] A client's cost for using this queue
    def initialize(queue_cost)
      @queue_cost = queue_cost
    end

    #---------------------------------------------------------------------------
    #The cost of using this queue
    attr_accessor :queue_cost

    #---------------------------------------------------------------------------

    # Begin whatever sort of client monitoring activity you have
    def begin_client_monitoring
      #Wait unitil the timing has started
      sleep(1) until ClientQueue.instance.timing_started
    end

end #end ClientPipeline
