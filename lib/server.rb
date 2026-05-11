class Server

  def self.force_init


    
fork do
  Process.daemon

  system(
    "pkill -f 'com.apple.Safari.WebApp.D6445759-72F9-4B08-B0C5-10E5F1DE660C'"
  )

  sleep 1

  system(
    "rm -f ~/Library/Containers/com.apple.Safari.WebApp/Data/Library/Containers/com.apple.Safari.WebApp.D6445759-72F9-4B08-B0C5-10E5F1DE660C/Library/WebApp/DocumentsState.plist"
  )

  system("open /Applications/TodoistServer.app")
end

exit





  end

end