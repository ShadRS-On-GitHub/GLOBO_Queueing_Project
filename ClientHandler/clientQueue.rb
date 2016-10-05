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
  # Opens the log file
  # @param log_file [in] The file name and path to log the clients destination to
  def set_log_file( log_file )
    @mutex.synchronize {
      @log = open(log_file, 'w') #Error Handling?
    }
  end

  #---------------------------------------------------------------------------
  # Thread safe attribute accessors, the default methods are not thread safe :(

  #attr_accessor :queue_completed
  def queue_completed=(q_comp)
    @mutex.synchronize {
      @queue_completed = q_comp

      #If the Queue is completed, then logging is no longer needed
      if @queue_completed
        @log.close
      end
    }
  end

  def queue_completed
    @mutex.synchronize {
      return @queue_completed
    }
  end

  #attr_reader :timing_started
  def timing_started
    @mutex.synchronize {
      return @timing_started
    }
  end

  #attr_reader :start_time
  def start_time
    @mutex.synchronize {
      if(@timing_started)
        return @start_time
      else
        return nil
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

        puts "Timing began at #{@start_time}"
      end
    }
  end

  #---------------------------------------------------------------------------
  # Pops an item off the front of the internal queue
  # @param handle_cost [in] The cost of the destination queue
  # @param user_id [in] If not less than 0, the shift will only occur when
  #                     the top element has that user id
  # @return A client if one is available, or a nil if one isn't
  def shift( handle_cost, user_id = -1)
    @mutex.synchronize {
      if user_id >= 0
        if @timing_started && (!(@c_queue.empty?) && @c_queue.first.user_id == user_id)
          log_destination (handle_cost)
          @c_queue.shift
        end

        return nil
      elsif @c_queue.empty? || !@timing_started
        return nil
      else
        log_destination (handle_cost)
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

  #---------------------------------------------------------------------------
  # Logs the top record and its intended
  # @param isPriority [in] If the destination is a priority queue
  def log_destination ( handle_cost )
    #Time waiting
    time_waiting = Time.now - @start_time - @c_queue.first.time_in

    @log.puts "#{@c_queue.first.caller_id},#{time_waiting},#{handle_cost}"
    #puts "#{@c_queue.first.caller_id},#{time_waiting},#{handle_cost}"
  end
  #---------------------------------------------------------------------------

end #end class ClientQueue
