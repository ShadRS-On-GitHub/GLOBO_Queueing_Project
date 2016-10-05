#clientMonitor.rb
# Monitors the client queue and makes sure that Clients haven't been
# waiting too long
# @author Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems


# Locally defined files/classes/modules
require_relative 'clientQueue.rb'

#---------------------------------------------------------------------------

class ClientMonitor

  #---------------------------------------------------------------------------
  # Basic initialization method
  # @param queue_cost [in] A client's cost for using this queue
  # @param time_out [in] The time at which a clent is moved to the Priority queue
  def initialize (queue_cost, time_out)
    @queue_cost = queue_cost
    @time_out = time_out
  end

  #---------------------------------------------------------------------------
  #---------------------------------------------------------------------------
  #The cost of using this queue
  attr_accessor :queue_cost
  #---------------------------------------------------------------------------

  # Begin the monitoring loop
  def begin_monitoring
    #Wait unitil the timing has started
    sleep(1) until ClientQueue.instance.timing_started

    until ClientQueue.instance.queue_completed do
      #Peek at the Queue and get the top item
      time_in, user_id = ClientQueue.instance.peek

      #If we have a valid client
      if user_id > -1
        age = Time.now - time_in
        #If the top one has been around too long, send it to priority
        if age >= @time_out
          ClientQueue.instance.shift(@queue_cost, user_id)
        else #Else it hasn't timed out yet
          #Sleep until this one is about to expire
          #The minus is to handle delays in processing
          time_to_wait = @time_out - age - 2
          if time_to_wait > 0
            sleep(time_to_wait)
          end

          #Note that nothing after this one will need to wait less time
          # This means that even if its not there when we loop back around
          # we'll just start looking at the next one
        end #end if (Time.now - time_in) >= time_out
      else
        #Nothing on the queue, so wait some time to avoid peppering the Queue
        # with endless requests
        sleep(@time_out * 0.9 )
      end #end if user_id > -1
    end #end until ClientQueue.instance.queue_completed do
  end #end begin_monitoring

  #---------------------------------------------------------------------------

end #end class ClientMonitor
