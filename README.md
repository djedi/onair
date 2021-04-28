# ON AIR

This script will check Brave Browser every 5 seconds to see if there is browser window open for Google Meet, GotoMeeting, or Zoom. If so, it will make a call to IFTTT to trigger my plug switch to turn on - which turns on a lamp. This will highlight my face better and let my family know that I am in a meeting.

For more infomation, see: https://dustindavis.me/blog/on-air-light-automation

## Set up

Edit `local.on-air.plist` - Change `IFTTT_PLACEHOLDER` to your IFTTT maker key and `/Users/username/src/onair` to your working directory.

Run the following to add this script to your launch control:

```shell
cp local.on-air.plist ~/Library/LaunchAgents/local.on-air.plist
launchctl load ~/Library/LaunchAgents/local.on-air.plist
```