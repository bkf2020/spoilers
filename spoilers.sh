#!/bin/sh

dialog --msgbox "Welcome to spoilers! This tool will give you 2 Pomodoro rounds of 50 minutes work and 10 minutes rest." 10 60
dialog --msgbox "When you are working, the internet will be completely turned off. If you need internet to submit a problem, press ENTER in the dialog box and you will get a two minute timer to submit." 10 60
dialog --yesno "Note that you will need NetworkManager installed. Do you have these installed? If not, install them and relaunch this script." 10 60 || exit
dialog --yesno "Once you are ready to start the first work session, press Yes. You can press No if you don't want to continue" 10 60 || exit

submittimer() {
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
		dialog --title "WORK SESSION" --timeout 60 --yes-label "" --no-label "I want to submit" --defaultno --yesno "$t minutes left. Press ENTER to get a 1 minute submit timer\n$PROGRESS_BAR" 10 60 || submittimer
		PROGRESS_BAR="$PROGRESS_BAR""#"
	done
}

breaktimer() {
	nmcli networking on
	for t in $(seq 10 -1 1)
	do
		dialog --title "BREAK SESSION" --timeout 60 --msgbox "$t minutes left.\n$PROGRESS_BAR" 10 60
		PROGRESS_BAR="$PROGRESS_BAR""#####"
	done
}

for i in seq 2
do
	worktimer
	breaktimer
done
