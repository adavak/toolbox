<#
Purpose:       Script to remove many of the pre-loaded Microsoft Metro "modern app" bloatware.
               Add any AppX package names to the $PackagesToRemove array to target them for removal
Requirements:  1. Administrator access
               2. Windows 7 and up
Author:        vocatus on reddit.com/r/TronScript ( vocatus.gate at gmail ) // PGP key: 0x07d1490f82a211a2
#>
$ErrorActionPreference = "SilentlyContinue"

########
# PREP #
########
$METRO_MICROSOFT_MODERN_APPS_TO_TARGET_BY_NAME_SCRIPT_VERSION = "1.1.7"
$METRO_MICROSOFT_MODERN_APPS_TO_TARGET_BY_NAME_SCRIPT_DATE = "2018-02-16"

# Build the removal function
Function Remove-App([String]$AppName){
	$PackageFullName = (Get-AppxPackage $AppName).PackageFullName
	$ProPackageFullName = (Get-AppxProvisionedPackage -online | where {$_.Displayname -like $AppName}).PackageName
	Remove-AppxPackage -package $PackageFullName | Out-Null
	Remove-AppxProvisionedPackage -online -packagename $ProPackageFullName | Out-Null
}

###########
# EXECUTE #
###########
# Active identifiers
Remove-App "*Microsoft.MinecraftUWP*"
Remove-App "*Microsoft.NetworkSpeedTest*"
Remove-App "*Microsoft.WindowsReadingList*"
Remove-App "Microsoft.3DBuilder"                       # 3DBuilder app
Remove-App "Microsoft.Advertising*"                    # Advertising framework
Remove-App "Microsoft.BingFinance"                     # Money app - Financial news
Remove-App "Microsoft.BingFoodAndDrink"                # Food and Drink app
Remove-App "Microsoft.BingHealthAndFitness"            # Health and Fitness app
Remove-App "Microsoft.BingNews"                        # Generic news app
Remove-App "Microsoft.BingSports"                      # Sports app - Sports news
Remove-App "Microsoft.BingTranslator"                  # Translator app - Bing Translate
Remove-App "Microsoft.BingTravel"                      # Travel app
Remove-App "Microsoft.CommsPhone"                      # Phone app
Remove-App "Microsoft.ConnectivityStore"
Remove-App "Microsoft.FreshPaint"                      # Canvas app
Remove-App "Microsoft.GetHelp"                         # Get Help link
Remove-App "Microsoft.Getstarted"                      # Get Started link
Remove-App "Microsoft.Messaging"                       # Messaging app
Remove-App "Microsoft.MicrosoftJackpot"                # Jackpot app
Remove-App "Microsoft.MicrosoftJigsaw"                 # Jigsaw app
Remove-App "Microsoft.MicrosoftOfficeHub"
Remove-App "Microsoft.MicrosoftPowerBIForWindows"      # Power BI app - Business analytics
Remove-App "Microsoft.MicrosoftSudoku"
Remove-App "Microsoft.MovieMoments"                    # imported from stage_2_de-bloat.bat
Remove-App "Microsoft.Office.OneNote"                  # Onenote app
Remove-App "Microsoft.Office.Sway"                     # Sway app
Remove-App "Microsoft.OneConnect"                      # OneConnect app
Remove-App "Microsoft.People"                          # People app
Remove-App "Microsoft.SkypeApp"                        # Get Skype link
Remove-App "Microsoft.SkypeWiFi"
Remove-App "Microsoft.Studios.Wordament"               # imported from stage_2_de-bloat.bat
Remove-App "Microsoft.WindowsFeedbackHub"              # Feedback app
Remove-App "Microsoft.Zune*"                           # Zune collection of apps
Remove-App "Microsoft.Appconnector"                   # Not sure about this one
Remove-App "Microsoft.BingWeather"                    # Weather app
Remove-App "Microsoft.Microsoft3DViewer"              # 3D model viewer
Remove-App "Microsoft.MicrosoftSolitaireCollection"   # Solitaire collection
Remove-App "Microsoft.MicrosoftStickyNotes"           # Pulled from active list due to user requests
Remove-App "Microsoft.Windows.Photos"                 # Photos app
Remove-App "Microsoft.WindowsAlarms"                  # Alarms and Clock app
Remove-App "Microsoft.WindowsCalculator"              # Calculator app
Remove-App "Microsoft.WindowsCamera"                  # Camera app
Remove-App "Microsoft.WindowsMaps"                    # Maps app
Remove-App "Microsoft.WindowsSoundRecorder"           # Sound Recorder app
Remove-App "Microsoft.WindowsStore"                   # Windows Store
Remove-App "Microsoft.windowscommunicationsapps"      # Calendar and Mail app
Remove-App "Microsoft.MSPaint"                        # MS Paint (Paint 3D)
Remove-App "Microsoft.ZuneMusic"
Remove-App "Microsoft.ZuneVideo"
Remove-App "Microsoft.Xbox*"
Remove-App "Microsoft.Xbox.TCUI"
Remove-App "Microsoft.XboxApp"
Remove-App "Microsoft.XboxGameCallableUI"
Remove-App "Microsoft.XboxGameOverlay"
Remove-App "Microsoft.XboxIdentityProvider"
Remove-App "Microsoft.XboxSpeechToTextOverlay"
Remove-App "89006A2E.AutodeskSketchBook"
Remove-App "A278AB0D.DisneyMagicKingdoms"
Remove-App "A278AB0D.MarchofEmpires"
Remove-App "DolbyLaboratories.DolbyAccess"
Remove-App "king.com.BubbleWitch3Saga"
Remove-App "king.com.CandyCrushSodaSaga"
Remove-App "Microsoft.AAD.BrokerPlugin"
Remove-App "Microsoft.AccountsControl"
Remove-App "Microsoft.Advertising.Xaml"
Remove-App "Microsoft.Advertising.Xaml"
Remove-App "Microsoft.BingNews"
Remove-App "Microsoft.BingWeather"
Remove-App "Microsoft.BioEnrollment"
Remove-App "Microsoft.CredDialogHost"
Remove-App "Microsoft.DesktopAppInstaller"
Remove-App "Microsoft.ECApp"
Remove-App "Microsoft.GetHelp"
Remove-App "Microsoft.Getstarted"
Remove-App "Microsoft.Messaging"
Remove-App "Microsoft.Microsoft3DViewer"
Remove-App "Microsoft.MicrosoftOfficeHub"
Remove-App "Microsoft.MicrosoftSolitaireCollection"
Remove-App "Microsoft.MicrosoftStickyNotes"
Remove-App "Microsoft.Office.OneNote"
Remove-App "Microsoft.OneConnect"
Remove-App "Microsoft.People"
Remove-App "Microsoft.PPIProjection"
Remove-App "Microsoft.Print3D"
Remove-App "Microsoft.Services.Store.Engagement"
Remove-App "Microsoft.Services.Store.Engagement"
Remove-App "Microsoft.SkypeApp"
Remove-App "Microsoft.StorePurchaseApp"
Remove-App "Microsoft.Wallet"
Remove-App "Microsoft.Windows.Apprep.ChxApp"
Remove-App "Microsoft.Windows.AssignedAccessLockApp"
Remove-App "Microsoft.Windows.CloudExperienceHost"
Remove-App "Microsoft.Windows.ContentDeliveryManager"
Remove-App "Microsoft.Windows.Cortana"
Remove-App "Microsoft.Windows.HolographicFirstRun"
Remove-App "Microsoft.Windows.OOBENetworkCaptivePortal"
Remove-App "Microsoft.Windows.OOBENetworkConnectionFlow"
Remove-App "Microsoft.Windows.ParentalControls"
Remove-App "Microsoft.Windows.PeopleExperienceHost"
Remove-App "Microsoft.Windows.Photos"
Remove-App "Microsoft.WindowsAlarms"
Remove-App "Microsoft.WindowsCamera"
Remove-App "microsoft.windowscommunicationsapps"
Remove-App "Microsoft.WindowsFeedbackHub"
Remove-App "Microsoft.WindowsMaps"
Remove-App "Microsoft.WindowsSoundRecorder"
Remove-App "Microsoft.WindowsStore"
Remove-App "Microsoft.Xbox.TCUI"
Remove-App "Microsoft.XboxApp"
Remove-App "Microsoft.XboxGameCallableUI"
Remove-App "Microsoft.XboxGameOverlay"
Remove-App "Microsoft.XboxIdentityProvider"
Remove-App "Microsoft.XboxSpeechToTextOverlay"
Remove-App "Microsoft.ZuneMusic"
Remove-App "Microsoft.ZuneVideo"
Remove-App "SpotifyAB.SpotifyMusic"
