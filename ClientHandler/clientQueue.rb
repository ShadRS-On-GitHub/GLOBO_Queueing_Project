#clientQueue.rb
# A singleton for accessing the clientQueue
# Should ideally be replaced with a database
# @author Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems
require 'singleton'
require 'thread'

# Locally defined files/classes/modules
require_relative '../Client/client.rb'

#---------------------------------------------------------------------------

class ClientQueue
  #Make this class a singleton
  include Singleton

  #---------------------------------------------------------------------------
  # Basic initialization method
  def initialize
    @queue_completed = false
    @timing_started = false
    @c_queue = Array.new
    @mutex = Mutex.new
  end

  #---------------------------------------------------------------------------
  # Thread safe attribute accessors, the default methods are not thread safe :(

  #attr_accessor :queue_completed
  def queue_completed=(q_comp)
    @mutex.synchronize {
      @queue_completed = q_comp
    }
  end

  def queue_completed
    @mutex.synchronize {
      @queue_completed
    }
  end

  #attr_reader :timing_started
  def timing_started
    @mutex.synchronize {
      @timing_started
    }
  end

  #attr_reader :start_time
  def start_time
    @mutex.synchronize {
      if(@timing_started)
        @start_time
      else
        nil
      end
    }
  end


  #---------------------------------------------------------------------------
  # Sets start_time to the current time and timing_started to true
  # But only if timing_started wasn't already true
  def begin_timing
    @mutex.synchronize {
      unless @timing_started
        @timing_started = true
        @start_time = Time.now
      end
    }
  end

  #---------------------------------------------------------------------------
  # If the top item on the queue has the given user_id, pop it off the queue
  # @param user_id [in] The user id to be matched to
  # @return Returns true if the removal was successful. false otherwise
  def send_to_priority(user_id)
    @mutex.synchronize {
      if @timing_started && (!(@c_queue.empty?) && @c_queue[0].user_id == user_id)
        @c_queue.pop
        return true
      end

      return false
    }

  end

  #---------------------------------------------------------------------------
  # Pops an item off the front of the internal queue
  # @return A client if one is available, or a nil if one isn't
  def shift
    @mutex.synchronize {
      if @c_queue.empty? || !@timing_started
        return nil
      else
        return @c_queue.shift
      end
    }
  end #end shift

  #---------------------------------------------------------------------------
  # Pushes an item onto the Queue
  # done so we don't give direct access to the queue
  def push (client)
    @mutex.synchronize {
      @c_queue.push (client)
    }
  end #end push


  #---------------------------------------------------------------------------
  # Gets information on the top client
  # @return time_in, user_id:
  # @return time_in The time the top client entered the queue
  # @return user_id The user id of the top client.  -1 if there are no items in the queue
  def peek
    @mutex.synchronize {
       if @c_queue.empty? || !@timing_started
         return 0, -1
       else
         return @c_queue.first.time_in, @c_queue.first.caller_id
       end
   }
  end
  #---------------------------------------------------------------------------

end #end class ClientQueue
