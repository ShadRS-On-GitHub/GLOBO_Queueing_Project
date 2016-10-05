# GLOBO_Queueing_Project
Coding demonstration for GLOBO job application.  

To execute: ruby launch_all.rb

This will create two seperate processes to handle the client queue.

Alternatively, execute: ruby ./ClientHandler/clientHandler.rb 
Followed by: ./AgentProcessor/agentProcessor.rb

This must be done is relatively quick succession or the two processes will time out.

Once a run is completed, the log file (destination_log_file.csv) will contain the desired results in a CSV format:
Caller ID, Time Waiting, Handle Cost

