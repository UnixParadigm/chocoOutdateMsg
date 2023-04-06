# Write current outdated packages to file
choco outdated -r > "$env:TEMP\chocoOutdatedPackages"

# Get num of packages to update
Get-Content "$env:TEMP\chocoOutdatedPackages" |%{ $PkgNum++ }

# If nothing to update, bail
if ($PkgNum -eq 0) {
	exit
} elseif ($PkgNum -eq 1) {
	$Messageboxbody = "Chocolatey has determined 1 package is outdated.`n`n"
} else {
	$Messageboxbody = "Chocolatey has determined $PkgNum packages are outdated.`n`n"
}
## Load libs
Add-Type -AssemblyName PresentationCore,PresentationFramework

## Put info in vars
$MessageboxTitle = "Chocolatey package update"
$Packages = Get-Content "$env:TEMP\chocoOutdatedPackages"
$Messageboxbody += $Packages -replace "\|false" -replace "\|true" -replace '^(.*?)\|','$1  ' -replace '(.*)\|(.*)','$1 => $2'
$Messageboxbody += "`n`nWould you like to update these packages?"

## Display formated msg of packages to update

## Background the messagebox so we can run command to focus it
Start-Job -Name 'MessageBox' -ArgumentList $Messageboxbody, $MessageboxTitle -ScriptBlock {
	Add-Type -AssemblyName PresentationCore,PresentationFramework
	[System.Windows.MessageBox]::Show($args[0],$args[1],"YesNo","Question") | Out-String
} | Out-Null

## Wait till messagebox window exists
while([string]::IsNullOrEmpty($MessageBoxExists)) {
	$MessageBoxExists = Get-Process | where {$_.mainWindowTitle -like "Chocolatey package update" }
}

## Focus messagebox window
$wshell = New-Object -ComObject wscript.shell
$wshell.AppActivate($MessageboxTitle)

## Wait and get answer from messagebox
$Answer = Wait-Job -Name 'MessageBox' | Receive-Job
	
## Update if desired
if ($Answer.Contains("Yes")) {
	Start-Process cmd -Argument "/c title Chocolatey package update && sudo choco upgrade all && timeout -1"
}
