#!/bin/bash

getConfirmation() {
  echo ""
	yesResponse="y"
	local noResponse="n"
	until [[ "$YnAnswer" == "$yesResponse" || "$YnAnswer" == "$noResponse" ]];
	do
		echo -n "Reply with 'y' only if you have all the apps listed otherwise reply with 'n' : "
		read YnAnswer
		YnAnswer=$(echo $YnAnswer | awk '{print tolower($0)}')
	done
}
dock_item() {
      printf '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>%s</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>', "$1"
}
dockChange() {
  defaults delete com.apple.dock persistent-apps
  defaults write com.apple.dock persistent-apps -array \
      "$(dock_item /System/Applications/Launchpad.app)" \
      "$(dock_item /System//Applications/Messages.app)" \
      "$(dock_item /Applications/"Google Chrome".app)" \
      "$(dock_item /Applications/"Microsoft Outlook".app)" \
      "$(dock_item /Applications/"Microsoft Word".app)" \
      "$(dock_item /Applications/"Microsoft PowerPoint".app)" \
      "$(dock_item /Applications/"Microsoft Excel".app)" \
      "$(dock_item /Applications/zoom.us.app)" \
      "$(dock_item /System/Applications/Calendar.app)" \
      "$(dock_item /System/Applications/"App Store".app)" \
      "$(dock_item /System/Applications/"System Preferences".app)"
  killall Dock
}
dialog() {
  echo "This script just reconfigures the Default Dock Apps"
  printf "The current apps on dock will be replaced by the following:\n1. Launchpad\n2. Messages\n3. Microsoft Outlook\n4. Microsoft Word\n5. Microsoft PowerPoint\n6. Microsoft Excel\n7. Zoom\n8. Calendar\n9. App Store\n10. System Preferences"
  echo ""
}
main() {
	clear
	dialog
	YnAnswer="x"
	getConfirmation $YnAnswer
	if [ "$YnAnswer" = "y" ]; then
		dockChange
	else
		echo "You selected no. Please return after apps are installed."
	fi
}
main
