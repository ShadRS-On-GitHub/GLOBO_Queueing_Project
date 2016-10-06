#testing_ExtendedQueue.rb
# Tests the ExtendedQueue module
# Should use an actual testing framework
# @author = Shad Scarboro
#---------------------------------------------------------------------------

# Existing Ruby Gems
require 'thread'

# Locally defined files/classes/modules
require_relative '../Client/client.rb'
require_relative '../ClientHandler/clientQueue.rb'

#---------------------------------------------------------------------------

ClientQueue.instance.push( Client.new(1, 2, 3))
ClientQueue.instance.push( Client.new(4, 5, 6))

puts "queue_completed: #{ClientQueue.instance.queue_completed} -> expect false"
puts "timing_started: #{ClientQueue.instance.timing_started} -> expect false"
puts "start_time: #{ClientQueue.instance.start_time} -> expect nil"

time_in, user_id = ClientQueue.instance.peek

puts "Peek before timing started, should be (0,-1) is: (#{time_in},#{user_id})"

ClientQueue.instance.begin_timing
start_time = ClientQueue.instance.start_time
puts "Queue started at #{start_time}"

time_in, user_id = ClientQueue.instance.peek
puts "Peek after timing started, should be (#{start_time+2},1) is: (#{time_in},#{user_id})"
clt = ClientQueue.instance.shift(1)
puts "shift after timing started, should be (#{start_time+2},1) is: #{clt}"

time_in2, user_id2 = ClientQueue.instance.peek
puts "Peek(2) after timing started, should be (#{start_time+5},4) is: (#{time_in2},#{user_id2})"
clt2 = ClientQueue.instance.shift(1)
puts "shift after timing started, should be (#{start_time+5},4) is: #{clt2}"
