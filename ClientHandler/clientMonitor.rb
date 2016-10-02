#clientMonitor.rb
#
# @author Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems


# Locally defined files/classes/modules
require 'clientQueue'

#---------------------------------------------------------------------------

class ClientMonitor

  #---------------------------------------------------------------------------
  # Basic initialization method
  # @param time_out [in] The time at which a clent is moved to the Priority queue
  def initialize (time_out)
    @time_out = time_out
  end

  #---------------------------------------------------------------------------
  # Basic attribute accessors

  #---------------------------------------------------------------------------

  # Begin the monitoring loop
  def begin_monitoring
    #Wait unitil the timing has started
    sleep(1) until ClientQueue.timing_started
    last_time = Time.now

    until ClientQueue.queue_completed do
      #Peek at the Queue and get the top item
      time_in, user_id = ClientQueue.peek

      

    end

  end #end begin_monitoring

  #---------------------------------------------------------------------------

end #end class ClientMonitor
