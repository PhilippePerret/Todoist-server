class Server

  def self.force_init
    
    

    
script = <<~BASH
sleep 2

pkill -f 'com.apple.Safari.WebApp.D6445759-72F9-4B08-B0C5-10E5F1DE660C'

while pgrep -f 'com.apple.Safari.WebApp.D6445759-72F9-4B08-B0C5-10E5F1DE660C' >/dev/null
do
  sleep 0.2
done

rm -f ~/Library/Containers/com.apple.Safari.WebApp/Data/Library/Containers/com.apple.Safari.WebApp.D6445759-72F9-4B08-B0C5-10E5F1DE660C/Library/WebApp/DocumentsState.plist

sleep 1

open /Applications/TodoistServer.app
BASH

Process.spawn(
  "/usr/bin/nohup",
  "/bin/bash",
  "-c",
  script,
  out: "/tmp/webapp-reset.log",
  err: "/tmp/webapp-reset.log"
)

exit




  end

end