#clientHandler.rb
#
# @author Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems
require 'socket'
require 'json'

# Locally defined files/classes/modules
require_relative '../Client/clientCommunications.rb'
require_relative '../Client/client.rb'
require 'queueServer'
require 'clientQueue'

#---------------------------------------------------------------------------
# Create the Client Queue, that keeps track of all the clients
c_queue = ClientQueue.new

#---------------------------------------------------------------------------
#initialization of the server
# Create TCP server
q_server = QueueServer.new (ClientCommunication::port, c_queue)

#---------------------------------------------------------------------------

#Launch operator thread
# The operator recieves incoming Clients and sorts them
c_operator = ClientOperator.new
operator_thread = Thread.new ( c_operator.recieve_clients)

#---------------------------------------------------------------------------

#launch monitor thread
# The monitor keeps track of the oldest client and sends them to the
# Priority Queue as necessary
c_monitor = ClientMonitor.new
monitor_thread = Thread.new ( c_monitor.begin_monitoring)

#---------------------------------------------------------------------------

# Everything is up, begin timing
ClientQueue.timing_started = true

#Is this needed?
#while ClientQueue.queue_completed
#end #end while ClientQueue.timing_started

#---------------------------------------------------------------------------
