#Launch the AgentProcessor
apThread = Thread.new {
  system( "cd AgentProcessor; ruby agentProcessor.rb")
}

handlerThread = Thread.new {
  system( "cd ClientHandler; ruby clientHandler.rb")
}


sleep(10)


#Close down threads
Thread.kill(apThread)
Thread.kill(handlerThread)
