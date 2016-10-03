#clientQueue.rb
# A singleton for accessing the clientQueue
# Should ideally be replaced with a database
# @author Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems
require 'singleton'

# Locally defined files/classes/modules

#---------------------------------------------------------------------------

class ClientQueue
  #Make this class a singleton
  include Singleton

  #---------------------------------------------------------------------------
  # Basic initialization method
  def initialize
    @queue_completed = false
    @timing_started = false
    @c_queue = Queue.new
  end

  #---------------------------------------------------------------------------
  # Basic attribute accessors
  attr_accessor :queue_completed
  attr_accessor :timing_started


  #---------------------------------------------------------------------------
  # Gets information on the top client
  # @return time_in, user_id:
  # @return time_in The time the top client entered the queue
  # @return user_id The user id of the top client.  -1 if there are no items in the queue
  def peek
    #????? This will necessitate some major changes
    abort
    #?????
  end

  #---------------------------------------------------------------------------
  # If the top item on the queue has the given user_id, pop it off the queue
  # @param user_id [in] The user id to be matched to
  def send_to_priority(user_id)
    #?????
    abort
    #?????
  end

  #---------------------------------------------------------------------------
  # Pops an item off the internal queue
  # @return A client if one is available, or a nil if one isn't
  def pop
    if c_queue.empty?
      return nil
    else
      return c_queue.pop
    end
  end #end pop

  #---------------------------------------------------------------------------
  # Pushes an item onto the Queue
  # done so we don't give direct access to the queue
  def push client
    c_queue.push (client)
  end #end push

  #---------------------------------------------------------------------------

end #end class ClientQueue
