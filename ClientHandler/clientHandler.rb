#clientHandler.rb
# The
# @author = Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems
require 'socket'
require 'json'

# Locally defined files/classes/modules
require_relative '../Client/clientCommunications.rb'
require_relative '../Client/client.rb'

#---------------------------------------------------------------------------
#initialization of the service
# Create TCP server
server = TCPServer.open(ClientCommunication::port)

start_time = Time.now

#Launch operator thread
# The operator recieves incoming Clients and sorts them
#????

#launch monitor thread
# The monitor keeps track of the oldest client and sends them to the
# Priority Queue as necessary

#Message Handler is the current thread

#---------------------------------------------------------------------------
loop {

}
