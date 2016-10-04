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
require_relative 'queueServer.rb'
require_relative 'clientQueue.rb'

#---------------------------------------------------------------------------
# Control values.  Should really be inputs instead of hardcoded
time_out_value = 60
client_file = "../GLOBOQueueDataForTest.csv"

#---------------------------------------------------------------------------
#initialization of the server
# Create TCP server
q_server = QueueServer.new (ClientCommunication::port)

#---------------------------------------------------------------------------

#Launch operator thread
# The operator recieves incoming Clients and sorts them
c_operator = ClientOperator.new(client_file)
operator_thread = Thread.new ( c_operator.recieve_clients)

#---------------------------------------------------------------------------

#launch monitor thread
# The monitor keeps track of the oldest client and sends them to the
# Priority Queue as necessary
c_monitor = ClientMonitor.new( time_out_value )
monitor_thread = Thread.new ( c_monitor.begin_monitoring)

#---------------------------------------------------------------------------

# Everything is up, begin timing
ClientQueue.instance.begin_timing

#Is this needed?
#while ClientQueue.instance.queue_completed
#end #end while ClientQueue.instance.timing_started

#---------------------------------------------------------------------------
