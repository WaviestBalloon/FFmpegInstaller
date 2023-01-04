Write-Output "Getting ready..."
$ProgressPreference = "SilentlyContinue"

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Output "It is recommended to run this script as administrator, as administrative permissions is required during the setup process. Proceeding will not modify your PATH and ffmpeg will only be available in this session only! Do you want to try running with administrator?`n(y/n/exit)"
	$continue = Read-Host
	if ($continue -eq "y") {
		Write-Output "`nExecuting script with administraive permissions... You may be prompted with UAC."
		Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" ;
		Write-Output "Installation continued in another terminal; exiting..."
		exit
	} elseif ($continue -eq "n") {
		Write-Output "`nDo you want to continue with installation anyways and add FFmpeg to PATH for this session only?`n(y/n)"
		$continue = Read-Host
		if ($continue -eq "y") {
			Write-Output "Continuing installation..."
		} else {
			Write-Output "Exiting..."
			exit
		}
	} else {
		Write-Output "Exiting..."
		exit
	}
} else {
	Write-Output "Running with administrative permissions (Good!)"
}

if (Test-Path "C:\ffmpeg") {
	Write-Output "`nSeems like FFmpeg is already installed here. Do you want to reinstall? This will purge the current FFmpeg directory.`n(y/n)"
	$reinstall = Read-Host
	if ($reinstall -eq "y") {
		Write-Output "`nRemoving old FFmpeg installation... Installation will continue automatically after this."
		Remove-Item "C:\ffmpeg" -Recurse
		Write-Output "Done! Continuing installation..."
	} else {
		Write-Output "Exiting..."
		exit
	}
}

Write-Output "`nDownloading latest FFmpeg build release..."
Invoke-WebRequest -Uri "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip" -OutFile "ffmpeg.zip"
Write-Output "Extracting FFmpeg..."
Expand-Archive -Path "ffmpeg.zip" -DestinationPath "C:\ffmpeg"
Write-Output "Moving files..."
Get-ChildItem -Path "C:\ffmpeg\ffmpeg-master-latest-win64-gpl" -Recurse -Directory | Move-Item -Destination "C:\ffmpeg"
Write-Output "Adding FFmpeg to PATH permanently..."
# check if path is already set
if ($env:Path -like "*C:\ffmpeg\bin*") {
	Write-Output "FFmpeg is already added to PATH. Skipping..."
} else {
	Write-Output "FFmpeg is not added to PATH. Adding..."
	[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\ffmpeg\bin", "Machine")
}
Write-Output "Adding FFmpeg to PATH for this session only..."
$env:Path += ";C:\ffmpeg\bin"
Write-Output "Cleaning up left overs..."
Remove-Item "ffmpeg.zip"
Remove-Item "C:\ffmpeg\ffmpeg-master-latest-win64-gpl" -Recurse
Write-Output "Done! FFmpeg is now installed and ready to use.`nYou should be able to run ffmpeg here! Although you may need to restart other terminals to be able to run ffmpeg."

Write-Host -NoNewLine "Press any key to exit...";
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown");
