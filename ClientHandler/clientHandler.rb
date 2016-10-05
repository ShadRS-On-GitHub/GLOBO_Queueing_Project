#clientHandler.rb
#
# @author Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems
require 'socket'
require 'json'
require 'thread'

# Locally defined files/classes/modules
require_relative '../Client/clientCommunications.rb'
require_relative '../Client/client.rb'
require_relative 'queueServer.rb'
require_relative 'clientMonitor.rb'
require_relative 'clientOperator.rb'
require_relative 'clientQueue.rb'

#---------------------------------------------------------------------------
# Control values.  Should really be inputs instead of hardcoded
time_out_value = 60
client_file = "../GLOBOQueueDataForTest.csv"
log_file = "../destination_log_file.csv"
standard_cost = 1
priority_cost = 2

#---------------------------------------------------------------------------
ClientQueue.instance.set_log_file( log_file )

#---------------------------------------------------------------------------
#initialization of the server
# Create TCP server
q_server = QueueServer.new(standard_cost, ClientCommunication::port)
server_thread = Thread.new { q_server.begin_client_monitoring }
puts "QueueServer started"

#---------------------------------------------------------------------------

#Launch operator thread
# The operator recieves incoming Clients and sorts them
c_operator = ClientOperator.new(client_file)
operator_thread = Thread.new { c_operator.recieve_clients }
puts "ClientOperator started"

#---------------------------------------------------------------------------

#launch monitor thread
# The monitor keeps track of the oldest client and sends them to the
# Priority Queue as necessary
c_monitor = ClientMonitor.new( priority_cost, time_out_value )
monitor_thread = Thread.new { c_monitor.begin_client_monitoring }
puts "ClientMonitor started"
#---------------------------------------------------------------------------

# Everything is up, begin timing
ClientQueue.instance.begin_timing

#Hold of getting to the joins until the queue has been completed
until ClientQueue.instance.queue_completed
  sleep (10)
end #end while ClientQueue.instance.timing_started

#---------------------------------------------------------------------------

# Clean up Threads
monitor_thread.join
operator_thread.join
server_thread.join
