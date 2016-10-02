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
  def peek
    #????? This will necessitate some major changes
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
