#!/bin/bash

getConfirmation () {
	echo ""
	YnAnswer="x"
	yesResponse="y"
	local noResponse="n"
	until [[ "$YnAnswer" == "$yesResponse" || "$YnAnswer" == "$noResponse" ]];
	do
		echo  "Downloads ready for $1 : "
		echo -n "Reply with 'y' or 'n' to begin downloads : "
		read YnAnswer
		YnAnswer=$(echo $YnAnswer | awk '{print tolower($0)}')
	done
}


dialogMenu () {
	clear
	echo "MacOS Quick Download Installer"
	echo ""
	echo "This bash program detects the chipset of this Mac"
	echo "and downloads the compatible installers."
	echo ""
	echo "The following installers will be downloaded : "
	echo "	1. Microsoft Office Installer"
	echo "	2. Zoom"
	echo "	3. Chrome Download"
	echo "	4. Adobe Creative Cloud"
	echo ""
}

universalInstallers() {
	echo Downloading Microsoft Office Installer ...
	curl -# https://officecdnmac.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_Office_16.64.22081401_BusinessPro_Installer.pkg > Downloads/Microsoft_Office_16.64.22081401_BusinessPro_Installer.pkg
	echo ""
	echo ""
	echo Downloading Zoom...
	curl -# https://cdn.zoom.us/prod/5.11.11.10514/Zoom.pkg > Downloads/Zoom.pkg
	echo ""
	echo ""
	echo Downloading Chrome Installer...
	curl -# https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg > Downloads/googlechrome.dmg
	echo ""
	echo ""
}


AppleSiliconInstallers() {
	echo "Downloading Adobe Creative Cloud(Silicon)..."
	curl -# https://ccmdl.adobe.com/AdobeProducts/KCCC/CCD/5_8_0/macarm64/ACCCx5_8_0_592.dmg > Downloads/AdobeCCInstaller.dmg
}

IntelInstallers () {
	echo "Downloading Adobe Creative Cloud(Intel)..."
	curl -# https://ccmdl.adobe.com/AdobeProducts/KCCC/CCD/5_8_0/osx10/ACCCx5_8_0_592.dmg > Downloads/AdobeCCInstaller.dmg
}

progressBar () {
  progressBarWidth=20
  # Calculate number of fill/empty slots in the bar
  progress=$(echo "$progressBarWidth/$taskCount*$tasksDone" | bc -l)
  fill=$(printf "%.0f\n" $progress)
  if [ $fill -gt $progressBarWidth ]; then
    fill=$progressBarWidth
  fi
  empty=$(($fill-$progressBarWidth))

  # Percentage Calculation
  percent=$(echo "100/$taskCount*$tasksDone" | bc -l)
  percent=$(printf "%0.2f\n" $percent)
  if [ $(echo "$percent>100" | bc) -gt 0 ]; then
    percent="100.00"
  fi

  # Output to screen
  printf "\r["
  printf "%${fill}s" '' | tr ' ' ▉
  printf "%${empty}s" '' | tr ' ' ░
  printf "] $percent%% - $text "
}

progressBarMain () {
	taskCount=5
	tasksDone=0

	while [ $tasksDone -le $taskCount ]; do

	# Do your task
	(( tasksDone += 1 ))


	# Draw the progress bar
	progressBar $taskCount $taskDone

	sleep 1
	done
}

main (){
	dialogMenu
	return_var="$(sysctl -n machdep.cpu.brand_string)"
	intelChip=0
	if [[ $return_var =~ "Intel" ]]; then
		intelChip=1
		echo "Processor Detected: Intel"
	else
		echo "Processor Detected: Apple Silicon"
	fi
	getConfirmation "$return_var"
	echo "
	"
	if [ "$YnAnswer" = "y" ]; then
		universalInstallers
		if [ "$intelChip" = 1 ]; then
			IntelInstallers
		else
			AppleSiliconInstallers
		fi
	echo ""
	echo ""
	echo "If any errors occurred feel free"
	echo "to use the standalone installers."
	sleep 1
	fi
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
}
main
exit
