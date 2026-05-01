#!/usr/bin/env ruby
# timer.rb
# Usage: ruby timer.rb <minutes>

minutes = (ARGV[0] || 5).to_f
seconds = (minutes * 60).to_i
html_path = File.expand_path(File.join(__dir__, 'timer.html'))
file_url  = "file://#{html_path}?t=#{seconds}"

def applescript(script) = system('osascript', '-e', script)
def bring_safari_front
  applescript(<<~AS)
    tell application "System Events"
      set frontmost of process "Safari" to true
    end tell
    tell application "Safari"
      activate
      set index of front window to 1
    end tell
  AS
end

applescript(<<~AS)
  tell application "Safari"
    activate
    make new document with properties {URL:"#{file_url}"}
    set bounds of front window to {100, 60, 560, 570}
  end tell
AS

warn_at = seconds - 600

if warn_at > 0
  sleep warn_at
  bring_safari_front
  sleep 600
else
  sleep seconds
end

bring_safari_front
