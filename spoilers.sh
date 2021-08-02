#!/bin/sh

dialog --msgbox "Welcome to spoilers! This tool will give you 2 Pomodoro rounds of 50 minutes work and 10 minutes rest." 10 60
dialog --msgbox "When you are working, the internet will be completely turned off. If you need internet to submit a problem, press ENTER in the dialog box to select the 'I need to submit' button and you will get a two minute timer to submit." 10 60
dialog --yesno "Note that you will need NetworkManager installed. Do you have this installed? If not, install it and relaunch this script." 10 60 || exit
dialog --yesno "Once you are ready to start the first work session, press 'Yes'. You can press 'No' if you don't want to continue" 10 60 || exit
clear
submittimer() {
	dialog --infobox "Waiting for NetworkManager to turn on internet. Don't worry: the timer hasn't started. Please be patient." 10 60
	nmcli networking on
	dialog --timeout 60 --msgbox "Submit your solution within the next two minutes" 10 60
	dialog --timeout 60 --msgbox "Submit your solution within the next minute" 10 60
}

worktimer() {
	PROGRESS_BAR=""
	for t in $(seq 50 -1 1)
	do
		if [ $(nmcli networking) = "enabled" ]
		then
			nmcli networking off
		fi
		PROGRESS_BAR="${PROGRESS_BAR}#"
		if [ $t = "50" ]
		then
			PROGRESS_BAR=""
		fi
		dialog --title "WORK SESSION" --timeout 60 --ok-label "I need to submit" --msgbox "$t minutes left.\nIf you need to submit, press ENTER to select the 'I need to submit' button. After that, you will get a 2 minute submit timer.\nIf you don't need to submit, don't press anything in this script and continue working.\n$PROGRESS_BAR" 12 60 || continue
		submittimer
	done
}

breaktimer() {
	PROGRESS_BAR=""
	nmcli networking on
	for t in $(seq 10 -1 1)
	do
		dialog --title "BREAK SESSION" --timeout 60 --msgbox "$t minutes left.\n$PROGRESS_BAR" 10 60
		PROGRESS_BAR="$PROGRESS_BAR""#####"
	done
}

for i in $(seq 2)
do
	worktimer
	breaktimer
done
