#!/usr/bin/env bash
# Info from:
# https://synthomat.de/blog/2020/01/increasing-the-file-descriptor-limit-on-macos/
# https://wilsonmar.github.io/maximum-limits/

file=/Library/LaunchDaemons/limit.maxfiles.plist
if [ -f $file]; then
  echo "File $file exists, if you have to change it do it by hand"
else
  sudo cat <<EOF >$file
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple/DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
    <dict>
      <key>Label</key>
        <string>limit.maxfiles</string>
      <key>ProgramArguments</key>
        <array>
          <string>launchctl</string>
          <string>limit</string>
          <string>maxfiles</string>
          <string>65536</string>
          <string>65536</string>
        </array>
      <key>RunAtLoad</key>
        <true />
    </dict>
  </plist>
EOF
  chmod 644 $file
  chown root:wheel $file
  sudo launchctl load -w $file
fi
