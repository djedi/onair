#!/bin/bash

# be sure to set global env var IFTTT_MAKER_KEY
export MEET_ON_AIR=new

function get_tabs () {
    local tabs=$(osascript tabs.osa)
    # echo $tabs
    local meet="https:\/\/meet\.google\.com"
    local gtm="https:\/\/global\.gotomeeting\.com\/join\/"
    local error="execution error"
    if [[ tabs =~ $error ]]; then
        echo "broke"
    else
        if [[ $tabs =~ $meet ]] || [[ $tabs =~ $gtm ]] || [[ $tabs =~ $zoom ]]; then
            echo "found"
            return
        fi
    fi

    # Check for MeetInOne app
    number=$(ps aux | grep -v grep | grep -ci MeetInOne)
    if [ $number -gt 0 ]; then
        echo "found";
        return
    fi

    # Check for Zoom app
    number=$(ps aux | grep -v grep | grep -ci Zoom)
    if [ $number -gt 0 ]; then
        echo "found";
        return
    fi

    echo "nomeet"
}

function check_meet () {
    local found=$(get_tabs)
    echo $found
    local trigger=0

    if [[ $found == "found" ]] ; then
        if [[ $MEET_ON_AIR != "on" ]] ; then
            echo "Turning on the light"
            /usr/local/bin/dark-mode off
            MEET_ON_AIR=on
            trigger=1
        fi
    fi
    if [[ $found == "nomeet" ]] ; then
        if [[ $MEET_ON_AIR != "off" ]] ; then
            echo "Triggering light out"
            /usr/local/bin/dark-mode on
            MEET_ON_AIR=off
            trigger=1
        fi
    fi
    if [[ $found == "broke" ]] ; then
        echo "Can't tell, ignoring"
    fi

    if [[ $trigger == 1 ]] ; then
        local url="https://maker.ifttt.com/trigger/meet-$MEET_ON_AIR/with/key/$IFTTT_MAKER_KEY"
        curl -X POST $url
    fi
}

check_meet

while :;
    do
    check_meet
    sleep 5
done
