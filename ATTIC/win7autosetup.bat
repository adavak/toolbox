REM ░█░█░▀█▀░█▀█░▀▀█░█▀█░█░█░▀█▀░█▀█░█▀▀░█▀▀░▀█▀░█░█░█▀█
REM ░█▄█░░█░░█░█░▄▀░░█▀█░█░█░░█░░█░█░▀▀█░█▀▀░░█░░█░█░█▀▀
REM ░▀░▀░▀▀▀░▀░▀░▀░░░▀░▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀░░.BAT
::
:: Windows 7 automated setup for offline personal gaming/multimedia/desktop machines
:: Installs Npackd + preset software list
:: Removes/disables/blocks unneeded/annoying services/telemetry/updates
:: Applies basic configuration tweaks
:: License: http://www.wtfpl.net/
:: Status: Archived. This file will no longer be updated (2018-02-26)
:: Use at your own risk
::
:: USAGE :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: Install Windows, run Windows Update, install all updates, Reboot as many times as necessary
:: Optional: Enable the local Administrator account in MMC console "users", login as Administrator
:: Optional: Delete the non-privilegied user account, remove the corresponding user profile
:: Save this script as WIN7AUTOSETUP.BAT
:: Edit the config options below if necessary, read the whole file, comment out unwanted changes
:: Start Menu > cmd.exe > right-click > run as administrator
:: cd C:\Users\example\Downloads\ && WIN7AUTOSETUP.BAT
:: Note: some installers will require manual driver installation approval (wincdemu, virtualbox...)
:: Check that the script exits with no errors
:: Reboot
:: Install other software/change other preferences
:: Recheck that no more Windows updates are available
:: Optional: Run sysprep /generalize /oobe /shutdown to generate a ready to clone/deploy Windows image
:: Optional: Clone the resulting disk image to the target machine using dd/clonezilla/VM cloning tool, or create a windows image with DISM (from a Windows PE installation), customize it with AD/WAIK, deploy it with with MDT.
:: If you don't want/need sysprep and only want to apply the settings to your current user, replace all occurences of HKEY_LOCAL_MACHINE with HKEY_CURRENT_USER. The admin account unlocking/normal account deletion step can also be ignored.
::
:: CONFIGURATION  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: Default set of Npackd packages to install
:: See https://github.com/nodiscc/toolbox/blob/master/ATTIC/windows-software.md for a basic software list including npackd package names
@set npackdpackagelist=com.microsoft.DotNetRedistributable, info.kowalczyk.blog.SumatraPDF, com.microsoft.SecurityEssentials64, org.safer-networking.SpyBotSearchAndDestroy, emet, org.7-zip.SevenZIP64, com.googlecode.windows-package-manager.NpackdInstallerHelper, libreoffice64, f.lux, org.mozilla.FirefoxESR, net.sourceforge.mumble.Mumble, com.oracle.JRE, org.deluge-torrent.Deluge, com.owncloud.OwnCloudClient, net.winscp.WinSCP, youtube-dl-gui, com.videolan.VLCMediaPlayer64, audacious, quod-libet, cccp64, ogg-codecs, org.electricsheep.ElectricSheep, winff64, net.sourceforge.audacity.Audacity, ar.com.buanzo.lame.LameForAudacity, mixxx, net.sourceforge.avidemux.Avidemux64, org.virtualdub.VirtualDub64, org.blender.Blender64, open-broadcaster-software, org.gimp.Gimp, org.gnome.live.dia.Dia, duplicate-files-finder, com.sweethome3d.SweetHome3D, com.sweethome3d.SH3DContributions, com.sweethome3d.SH3DKatorLega, com.sweethome3d.SH3DLucaPresidente, com.sweethome3d.SH3DReallusion, com.sweethome3d.SH3DScopia, com.sweethome3d.SH3DTrees, net.nirsoft.Launcher, com.github.bmatzelle.Gow, sysinternals-suite, open-hardware-monitor, bleachbit, org.sysprogs.WinCDEmu64, universal-usb-installer, org.cgsecurity.testdisk.TestDisk64, wsus-offline-updater, com.microsoft.ProcessExplorer, info.windirstat.WinDirStat, org.virtualbox.virtualbox64, pwgen, net.sourceforge.FreeFileRenamer, win32-disk-imager, com.angusj.ResourceHacker, crystaldiskinfo, notepadpp64, net.sourceforge.console.Console, meld, uk.org.greenend.chiark.sgtatham.Putty, com.twinery.twine64, savegamebackup.net, sublime-text64, git64
::
:: Packages requiring an Internet connection to install, even when a local copy is available
:: Will be installed at the end of process
@set npackdinternetrequired=com.steampowered.Steam
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

REM INSTALL SOFTWARE

REM Download Npackd
IF NOT EXIST "Npackd64-1.22.2.msi" (
        powershell -command "$clnt = new-object System.Net.WebClient; $clnt.DownloadFile(\"https://github.com/tim-lebedkov/npackd-cpp/releases/download/version_1.22.2/Npackd64-1.22.2.msi\", \"Npackd64-1.22.2.msi\")" || echo ERROR && exit /b
)
IF NOT EXIST "NpackdCL-1.22.2.msi" (
        powershell -command "$clnt = new-object System.Net.WebClient; $clnt.DownloadFile(\"https://github.com/tim-lebedkov/npackd-cpp/releases/download/version_1.22.2/NpackdCL-1.22.2.msi\", \"NpackdCL-1.22.2.msi\")" || echo ERROR && exit /b
)

REM Install Npackd and NpackdCL
Npackd64-1.22.2.msi || echo ERROR && exit /b
NpackdCL-1.22.2.msi || echo ERROR && exit /b

REM Please allow some time for Npackd to update the remote repository, then exit npackd
REM Optional: Copy your offline Npackd repository to npackd-repository/
REM Optional: add your offline repository file://C:\...\Rep.xml to Npackd repositories list manually, and apply
"c:\Program Files\NPackd\npackdg.exe"

REM Install preset packages
:: Package list can be configured above
:: https://github.com/tim-lebedkov/npackd/wiki/CommandLine
for %%x in (%npackdpackagelist%) do start /wait "" "C:\Program Files (x86)\NpackdCL\ncl.exe" add --non-interactive --package=%%x || echo ERROR && exit /b

:: ###################################################################

REM DISABLE SERVICES

REM Networking ::::::::::::::::::::::::::::::::::::

REM Disable computer and resources network publication
sc stop FDResPub
sc config FDResPub start= disabled || echo ERROR && exit /b

REM disable IPv6 oper IPv4
sc stop iphlpsvc
sc config iphlpsvc start= disabled || echo ERROR && exit /b

REM Disable server (file, print, and named-pipe sharing)
:: http://www.blackviper.com/windows-services/server/
sc stop LanmanServer
sc config LanmanServer start= disabled || echo ERROR && exit /b

REM Disable NetBIOS over TCP/IP
sc stop LmHosts
sc config LmHosts start= disabled || echo ERROR && exit /b

REM Disable Home Group
sc stop HomeGroupProvider
sc stop HomeGroupListener
sc config HomeGroupProvider start= disabled
sc config HomeGroupListener start= disabled || echo ERROR && exit /b

REM Disable auto connection to remote network when a program calls a remote DNS or NetBIOS name
:: http://www.blackviper.com/windows-services/remote-access-auto-connection-manager/
sc stop RasAuto
sc config RasAuto start= disabled || echo ERROR && exit /b

REM Disable direct DSL/Phone dialing
:: http://www.blackviper.com/windows-services/remote-access-connection-manager/
sc stop RasMan
sc config RasMan start= disabled || echo ERROR && exit /b

REM Disable Routing and Remote Access
:: http://www.blackviper.com/windows-services/routing-and-remote-access/
sc stop RemoteAccess
sc config RemoteAccess start= disabled  || echo ERROR && exit /b

REM Disable remote registry
:: http://www.blackviper.com/windows-services/remote-registry/
sc stop RemoteRegistry
sc config RemoteRegistry start= disabled || echo ERROR && exit /b

REM Disable network connection sharing
:: http://www.blackviper.com/windows-services/windows-firewallinternet-connection-sharing-ics/
sc stop SharedAccess
sc stop ALG
sc config SharedAccess start= disabled
sc config ALG start= disabled || echo ERROR && exit /b

REM Disable network uPnP devices detection
:: http://www.blackviper.com/windows-services/ssdp-discovery-service/
:: http://www.blackviper.com/windows-services/function-discovery-provider-host/
sc stop SSDPSRV
sc stop fdPHost
sc config SSDPSRV start= disabled
sc config fdPHost start= disabled || echo ERROR && exit /b

REM Disable mobile broadband network autoconfiguration
:: http://www.blackviper.com/windows-services/wwan-autoconfig/
sc stop WwanSvc
sc config WwanSvc start= disabled || echo ERROR && exit /b

REM Disable maintaining a list of network resources
:: http://www.blackviper.com/windows-services/computer-browser/
:: When file sharing is enabled, network shares will take longer to discover
sc stop Browser
sc config Browser start= disabled || echo ERROR && exit /b

REM Disable bluetooth
sc stop bthserv
sc config bthserv start= disabled || echo ERROR && exit /b

:: ###################################################################

REM :: Performance :::::::::::::::::::::::::::::::::::::::::::::::::::

REM Disable antimalware service (MSE) (Performance)
:: Suspicious incoming files must be scanned manually
:: Run weekly full scans
:: TODO UNSTOPPABLE, MUST BE STOPPED IN SAFE MODE
:: sc stop MsMpSvc
:: sc config MsMpSvc start= disabled || echo ERROR && exit /b

REM Disable Windows Defender network inspection (performance)
:: TODO UNSTOPPABLE, MUST BE STOPPED IN SAFE MODE
:: sc stop NisSrv
:: sc config NisSrv start= disabled || echo ERROR && exit /b

REM Disable windows defender (performance)
sc stop WinDefend
sc config WinDefend start= disabled || echo ERROR && exit /b

REM Disable themes (aero) (performance)
sc stop Themes
sc config Themes start= disabled || echo ERROR && exit /b

REM Disable transparency, window previews, back to basic style (performance)
sc stop UxSms
sc config UxSms start= disabled || echo ERROR && exit /b

REM Disable file content search and indexing (performance)
:: File searches will be slower
:: http://www.blackviper.com/windows-services/windows-search/
sc stop WSearch
sc config WSearch start= disabled || echo ERROR && exit /b

:: ###################################################################

REM :: Ununsed services/Telemetry/Reporting/Annoyances :::::::::::::::

REM Disable event log (disabled) (required for task manager)
:: sc stop eventlog
:: sc config eventlog start= disabled || echo ERROR && exit /b

REM Disable windows error reporting service
sc stop WerSvc
sc config WerSvc start= disabled || echo ERROR && exit /b

REM Disable Application Experience (checking microsoft database for workarounds to known problems)
:: http://www.blackviper.com/windows-services/application-experience/
sc stop AeLookupSvc
sc config AeLookupSvc start= disabled || echo ERROR && exit /b

REM Disable Diagnostic Tracking Service
sc stop Diagtrack
sc config Diagtrack start= disabled

REM Disable print spooler (disabled)
:: Printer service must ben enable manually
:: sc stop Spooler
:: sc config Spooler start= disabled || echo ERROR && exit /b

REM Disable scanners and cameras
sc stop :: stisvc
sc config stisvc start= disabled || echo ERROR && exit /b

REM Disable biometric services (fingerprint sensors)
:: http://www.blackviper.com/windows-services/windows-biometric-service/
sc stop WbioSrvc
sc config WbioSrvc start= disabled || echo ERROR && exit /b

REM Disable Tablet PC Input Service
:: http://www.blackviper.com/windows-services/tablet-pc-input-service/
sc stop TabletInputService
sc config TabletInputService start= disabled || echo ERROR && exit /b

REM Disable offline files
sc stop cscservice
sc config cscservice start= disabled || echo ERROR && exit /b

REM Disable Volume Shadow Copy (VSS, windows backups)
sc stop VSS
sc config VSS start= disabled || echo ERROR && exit /b

REM Disable parental controls
sc stop WPCSvc
sc config WPCSvc start= disabled || echo ERROR && exit /b

REM Disable copy of user certificates and root certificates from smart cards
sc stop CertPropSvc
sc config CertPropSvc start= disabled || echo ERROR && exit /b

REM Disable NTFS link tracking
sc stop TrkWks
sc stop TrkSrv
sc config TrkWks start= disabled
sc config TrkSrv start= disabled

REM Disable security center
sc stop wscsvc
sc config wscsvc start= disabled || echo ERROR && exit /b

REM Disable Encrypting File System
sc stop EFS
sc config EFS start= disabled || echo ERROR && exit /b

REM Disable bitlocker
sc stop BDESVC
sc config BDESVC start= disabled || echo ERROR && exit /b

REM Disable Diagnostic Policy Service (problem detection, troubleshooting and resolution)
sc stop DPS
sc stop WdiSystemHost
sc config DPS start= disabled
sc config WdiSystemHost start= disabled || echo ERROR && exit /b

:: ################################################################

REM REMOVE/DISABLE BAD UPDATES/TELEMETRY

rem Remove bad updates
:: See https://support.microsoft.com/en-us/kb/UPDATE_NUMBER

wusa /uninstall /kb:971033 /quiet /norestart
wusa /uninstall /kb:2882822 /quiet /norestart
wusa /uninstall /kb:2902907 /quiet /norestart
wusa /uninstall /kb:2922324 /quiet /norestart
wusa /uninstall /kb:2952664 /quiet /norestart
wusa /uninstall /kb:2976978 /quiet /norestart
wusa /uninstall /kb:2977759 /quiet /norestart
wusa /uninstall /kb:2990214 /quiet /norestart
wusa /uninstall /kb:2999226 /quiet /norestart
wusa /uninstall /kb:3012973 /quiet /norestart
wusa /uninstall /kb:3014460 /quiet /norestart
wusa /uninstall /kb:3015249 /quiet /norestart
wusa /uninstall /kb:3021917 /quiet /norestart
wusa /uninstall /kb:3022345 /quiet /norestart
wusa /uninstall /kb:3035583 /quiet /norestart
wusa /uninstall /kb:3042058 /quiet /norestart
wusa /uninstall /kb:3044374 /quiet /norestart
wusa /uninstall /kb:3046480 /quiet /norestart
wusa /uninstall /kb:3050265 /quiet /norestart
wusa /uninstall /kb:3050267 /quiet /norestart
wusa /uninstall /kb:3058168 /quiet /norestart
wusa /uninstall /kb:3064683 /quiet /norestart
wusa /uninstall /kb:3065987 /quiet /norestart
wusa /uninstall /kb:3065988 /quiet /norestart
wusa /uninstall /kb:3068707 /quiet /norestart
wusa /uninstall /kb:3068708 /quiet /norestart
wusa /uninstall /kb:3072318 /quiet /norestart
wusa /uninstall /kb:3074677 /quiet /norestart
wusa /uninstall /kb:3075249 /quiet /norestart
wusa /uninstall /kb:3075851 /quiet /norestart
wusa /uninstall /kb:3075853 /quiet /norestart
wusa /uninstall /kb:3080149 /quiet /norestart
wusa /uninstall /kb:3080351 /quiet /norestart
wusa /uninstall /kb:3081437 /quiet /norestart
wusa /uninstall /kb:3081454 /quiet /norestart
wusa /uninstall /kb:3081954 /quiet /norestart
wusa /uninstall /kb:3083324 /quiet /norestart
wusa /uninstall /kb:3083325 /quiet /norestart
wusa /uninstall /kb:3083710 /quiet /norestart
wusa /uninstall /kb:3083711 /quiet /norestart
wusa /uninstall /kb:3088195 /quiet /norestart
wusa /uninstall /kb:3090045 /quiet /norestart
wusa /uninstall /kb:3093983 /quiet /norestart
wusa /uninstall /kb:3102810 /quiet /norestart
wusa /uninstall /kb:3102812 /quiet /norestart
wusa /uninstall /kb:3112336 /quiet /norestart
wusa /uninstall /kb:3112343 /quiet /norestart
wusa /uninstall /kb:3118401 /quiet /norestart
wusa /uninstall /kb:3123862 /quiet /norestart
wusa /uninstall /kb:3135445 /quiet /norestart
wusa /uninstall /kb:3135449 /quiet /norestart
wusa /uninstall /kb:3138612 /quiet /norestart
wusa /uninstall /kb:3139929 /quiet /norestart
wusa /uninstall /kb:3173040 /quiet /norestart

REM Create temp script to block windows updates
FINDSTR /E "'BLOCKUPDATESVBS" "%~f0" >block_windows_updates.vbs || echo ERROR && exit /b

REM Disable and hide bad updates
start "" /b /wait cscript.exe "block_windows_updates.vbs" 2882822 3050265 3065987 3075851 3102810 3118401 3135445 3138612 3173040 971033 3123862 3112336 3090045 3083711 3083710 || echo ERROR && exit /b

REM Batch 2
start "" /b /wait cscript.exe "block_windows_updates.vbs" 3081954 3081454 3081437 3080351 3080149 3075249 3074677 3072318 3068708 3068707 3064683 3058168 3046480 3044374 3035583 || echo ERROR && exit /b

REM Batch 3
start "" /b /wait cscript.exe "block_windows_updates.vbs" 3022345 3021917 3015249 3014460 3012973 2990214 3139929 2977759 2976987 2976978 2952664 2922324 2902907 3112343 3083324 3083325 || echo ERROR && exit /b

REM Batch 4
start "" /b /wait cscript.exe "block_windows_updates.vbs" 2902907 2922324 2952664 2976978 2977759 2990214 2999226 3042058 3050267 3075853 3065988 || echo ERROR && exit /b

REM Batch 5
:: Ignore and hide these updates
:: kb2562937 activex security update
:: kb890830 microsft malware removal tool
:: kb2387530,Fix for Wi-Fi protected setup
:: kb2454826,Graphics/WMF fixes
:: kb2467023, less restarts after upgrading ie9
:: kb2998812, compatibility appraiser update
:: kb3015428, fix incorrect AC/battery status preventing SP1 installation
:: kb976422, fix incorrect detected capacity of >32GB SD cards
:: kb2506928,fix outlook html file handling
:: kb2545698,fix fonts in IE8
:: kb2547666,fix history in IE
:: kb2563227,fix SVG in IE
:: kb2592687,RDP update
:: kb2603229,fix licensing info display in regedit
:: kb2640148,fix for explorer.exe mapped drive expansion crash
:: kb2660075,fix for samoa timezone
:: kb2719857,fix for USB RNDIS 3G4G connections
:: kb2726535,add south sudan to country list
start "" /b /wait cscript.exe "block_windows_updates.vbs" 2562937 890830 2506928 2545698 2547666 2563227 2592687 2603229 2640148 2660075 2719857 2726535 || echo ERROR && exit /b

REM Remove temporary script
del block_windows_updates.vbs || echo ERROR && exit /b

REM Kill pending tracking reports
mkdir %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\
echo. > %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl 2>NUL
echo y|cacls.exe "%programdata%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" /d SYSTEM 2>NUL || echo ERROR && exit /b

REM Disable telemetry via master registry key
REM GPO options to disable telemetry
%windir%\system32\reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
%windir%\system32\reg.exe add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f || echo ERROR && exit /b

REM Disable Wifi sense
%windir%\system32\reg.exe add "HKLM\software\microsoft\wcmsvc\wifinetworkmanager" /v "wifisensecredshared" /t REG_DWORD /d "0" /f
%windir%\system32\reg.exe add "HKLM\software\microsoft\wcmsvc\wifinetworkmanager" /v "wifisenseopen" /t REG_DWORD /d "0" /f || echo ERROR && exit /b

REM Disable Windows Defender sample reporting (spynet)
REM TODO ACCESS DENIED, MUST BE DONE IN SAFE MODE OR MANUALLY IN MSE
:: %windir%\system32\reg.exe add "HKLM\software\microsoft\windows defender\spynet" /v "spynetreporting" /t REG_DWORD /d "0" /f
:: %windir%\system32\reg.exe add "HKLM\software\microsoft\windows defender\spynet" /v "submitsamplesconsent" /t REG_DWORD /d "0" /f || echo ERROR && exit /b

REM Disable SkyDrive
%windir%\system32\reg.exe add "HKLM\software\policies\microsoft\windows\skydrive" /v "disablefilesync" /t REG_DWORD /d "1" /f || echo ERROR && exit /b

REM Kill OneDrive from hooking into Explorer even when disabled
%windir%\system32\reg.exe add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f
%windir%\system32\reg.exe add "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f || echo ERROR && exit /b

REM Disable Diagtrack Autologger
%windir%\system32\reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d "0" /f || echo ERROR && exit /b

REM Disable DiagTrack service
%windir%\system32\reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f || echo ERROR && exit /b

REM Disable WAP Push Message Routing Service
%windir%\system32\reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f || echo ERROR && exit /b

REM Delete telemetry scheduled tasks
schtasks /delete /F /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
schtasks /delete /F /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
schtasks /delete /F /TN "\Microsoft\Windows\Autochk\Proxy"
schtasks /delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
schtasks /delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
schtasks /delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
schtasks /delete /F /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
schtasks /delete /F /TN "\Microsoft\Windows\PI\Sqm-Tasks"
schtasks /delete /F /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
schtasks /delete /F /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting"

:: ###################################################################

REM TWEAKS/DEBLOAT

REM Disable fully automatic reboot while users are logged on
:: http://www.sevenforums.com/tutorials/6042-windows-update-enable-disable-automatic-restart.html
%windir%\system32\reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "1" /f
%windir%\system32\reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AlwaysAutoRebootAtScheduledTime" /t REG_DWORD /d "0" /f || echo ERROR && exit /b

REM Show UAC Allow/Deny prompt for all privilegied operations, including from Windows binaries
:: https://msdn.microsoft.com/en-us/library/cc232761.aspx
:: Set to 1 to ask for password on UAC prompt
%windir%\system32\reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "2" /f || echo ERROR && exit /b

REM Disable SMBv1
:: https://support.microsoft.com/fr-fr/help/2696547/how-to-enable-and-disable-smbv1-smbv2-and-smbv3-in-windows-and-windows-server
%windir%\system32\reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "SMB1" /t REG_DWORD /d "0" /f || echo ERROR && exit /b

REM Always show all icons and notifications on the taskbar
%windir%\system32\reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d "2" /f || echo ERROR && exit /b

REM Disable windows features (mediaplayer/xpsviewer)
Dism /online /NoRestart /Disable-Feature /FeatureName:WindowsMediaPlayer
Dism /online /NoRestart /Disable-Feature /FeatureName:Xps-Foundation-Xps-Viewer

REM Set power mode to "high performance"
powercfg /S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c || echo ERROR && exit /b

REM Disable event sounds
%windir%\system32\reg.exe add "HKEY_LOCAL_MACHINE\AppEvents\Schemes" /t REG_SZ /d ".None" /f || echo ERROR && exit /b

REM Show file extensions
%windir%\system32\reg.exe add  "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t REG_DWORD /v HideFileExt /d 0 /f || echo ERROR && exit /b

REM Disable Autoplay
%windir%\system32\reg.exe add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v DisableAutoplay

REM Don't ask to search the internet for the correct program when opening a file with an unknown extension
%windir%\system32\reg.exe add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoInternetOpenWith /t REG_DWORD /d 1 /f

REM Configure sysprep not to remove manually installed drivers (disabled)
:: %windir%\system32\reg.exe add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Setup\Syspre\Settings\sppnp" /v PersistAllDeviceInstalls /t REG_DWORD /d 1 /f

REM Show hidden files
:: (1: Show, 2: Don't show)
:: Show Protected Operating System Files
:: Display Contents of System Folders
reg add  "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t REG_DWORD /v Hidden /d 1 /f
reg add  "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t REG_DWORD /v SuperHidden     /d 1 /f
reg add  "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t REG_DWORD /v ShowSuperHidden /d 1 /f || echo ERROR && exit /b

REM create godmode directory on desktop
mkdir C:\Users\Public\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}

:: ###################################################################

REM FINALIZE CONFIGURATION

REM Run Full AV Scan (disabled)
:: start /wait "" "C:\Program Files\Microsoft Security Client\Antimalware\MPCMDRUN.EXE" -Scan -2

REM Clean temp files
CLEANMGR /C: /sageset:0 || echo ERROR && exit /b

REM Run misc programs (disabled)
:: start /wait "c:\Program Files\Bleachbit\bleachbit.exe"
:: start /wait "c:\Program Files\Spybot S&D\Spybot.exe"
:: start /wait defrag /C
:: start /wait "c:\Program Files\NPackd\npackdg.exe"
:: wuauclt.exe /detectnow /updatenow || echo ERROR && exit /b
start /wait msconfig || echo ERROR && exit /b

REM Install Npackd packages requiring an Internet connection
REM Please connect the machine to the Internet now
:: Package list can be configured above
for %%x in (%npackdinternetrequired%) do start /wait "" "C:\Program Files (x86)\NpackdCL\ncl.exe" add --non-interactive --package=%%x || echo ERROR && exit /b

EXIT

:: ###################################################################

:: VBScript to block windows updates/permanently remove them from the update list

If Wscript.Arguments.Count < 1 Then 'BLOCKUPDATESVBS
    WScript.Echo "Syntax: block_windows_updates.vbs [Hotfix Article ID]" & vbCRLF & " - Examples: block_windows_updates.vbs 2990214" & vbCRLF & " - Examples: block_windows_updates.vbs 3022345 3035583" 'BLOCKUPDATESVBS
    WScript.Quit 1 'BLOCKUPDATESVBS
End If 'BLOCKUPDATESVBS

Dim objArgs 'BLOCKUPDATESVBS
Set objArgs = Wscript.Arguments 'BLOCKUPDATESVBS
Dim updateSession, updateSearcher 'BLOCKUPDATESVBS
Set updateSession = CreateObject("Microsoft.Update.Session") 'BLOCKUPDATESVBS
Set updateSearcher = updateSession.CreateUpdateSearcher() 'BLOCKUPDATESVBS

Wscript.Stdout.Write " Searching for updates..." 'BLOCKUPDATESVBS
Wscript.Echo " This takes a LONG time, often more than 30 minutes." 'BLOCKUPDATESVBS
Wscript.Stdout.Write " If it hangs for over 2 hours, kill cscript.exe with Task Manager" 'BLOCKUPDATESVBS
Wscript.Echo "" 'BLOCKUPDATESVBS
Dim searchResult 'BLOCKUPDATESVBS
Set searchResult = updateSearcher.Search("IsInstalled=0") 'BLOCKUPDATESVBS

Dim update, kbArticleId, index, index2 'BLOCKUPDATESVBS
WScript.Echo CStr(searchResult.Updates.Count) & " found." 'BLOCKUPDATESVBS
For index = 0 To searchResult.Updates.Count - 1 'BLOCKUPDATESVBS
    Set update = searchResult.Updates.Item(index) 'BLOCKUPDATESVBS
    For index2 = 0 To update.KBArticleIDs.Count - 1 'BLOCKUPDATESVBS
	kbArticleId = update.KBArticleIDs(index2) 'BLOCKUPDATESVBS
	For Each hotfixId in objArgs 'BLOCKUPDATESVBS
	    If kbArticleId = hotfixId Then 'BLOCKUPDATESVBS
	        If update.IsHidden = False Then 'BLOCKUPDATESVBS
	            WScript.Echo "Hiding update: " & update.Title 'BLOCKUPDATESVBS
	            update.IsHidden = True 'BLOCKUPDATESVBS
	        Else 'BLOCKUPDATESVBS
	            WScript.Echo "Already hidden: " & update.Title 'BLOCKUPDATESVBS
	        End If 'BLOCKUPDATESVBS
	    End If 'BLOCKUPDATESVBS
	Next 'BLOCKUPDATESVBS
    Next 'BLOCKUPDATESVBS
Next 'BLOCKUPDATESVBS

:: ###################################################################
:: # TODO
::
:: TODO remove npackd dependency, write NuGet repository
:: TODO [enh] better error handling...
:: TODO [bug] npackd: some interactive install dialogs still popup (electricsheep)
:: TODO [bug] some services must be stopped in safe mode
:: TODO [enh] create custom files in \Users\Public\ if needed (desktop shortcuts...)
:: TODO [enh] automatically create spybot whitelist after installation
:: TODO [enh] disable windows games updates
:: TODO [enh] MSE Options: disable resident, scan USB drives?
:: TODO [enh] owncloud: switch to Nextcloud
:: TODO [enh] Set wallpaper
:: TODO [enh] Set updates to "let me select updates"
:: TODO [enh] Set updates to "do not install recommended updates"
:: TODO [enh] Disable "microsoft update" (updates for microsoft peripherals)
:: TODO [enh] Make disabling printers/SMB/file indexing configurable/optional
:: TODO [enh] showing hidden files/system files/folders test??
:: TODO [enh] Firefox config https://github.com/nodiscc/user.js + addons https://github.com/nodiscc/dbu/blob/master/Makefile
:: TODO [enh] Update npackd repository from command line?
:: TODO [enh] Allow adding local npackd-repository/Rep.xml to npackd repos
:: TODO [enh] run npackd installers silently https://github.com/tim-lebedkov/npackd/wiki/CommandLineInstallation
:: TODO [enh] hide more updates: skype, defender, optional updates...
:: TODO [enh] disable "allow remote assistance connections to this computer"
:: TODO [maybe] rewrite in powershell 2.0?
:: TODO [maybe] Use gpupdate/GPO
:: TODO [maybe] improve output/prompt...
::
:: ###################################################################
:: # Windows software
:: 
:: http://npackd.appspot.com/p is a package manager for Windows.
:: Install/remove/update all software from a single application.
:: Full list of available software: http://npackd.appspot.com/p
:: A basic software list can be found below.
:: 
:: ## Office
:: 
:: SumatraPDF http://blog.kowalczyk.info/software/sumatrapdf/download-free-pdf-viewer.html `info.kowalczyk.blog.SumatraPDF`
:: Libreoffice https://www.libreoffice.org/download/ `libreoffice64`
:: PDF Creator http://sourceforge.net/projects/pdfcreator/ `org.pdfforge.PDFCreator` (! also installs pdf architect)
:: Xournal http://xournal.sourceforge.net/
:: 
:: ## Network/Web
:: 
:: Mozilla Firefox ESR https://www.mozilla.org/en-US/firefox/all.html `org.mozilla.FirefoxESR`
:: Mozilla Thunderbird https://www.mozilla.org/fr/thunderbird/
:: Pidgin http://pidgin.im/download/
:: Pidgin-OTR http://www.cypherpunks.ca/otr/index.php#downloads
:: Mumble http://mumble.sourceforge.net/ `net.sourceforge.mumble.Mumble`
:: Deluge http://dev.deluge-torrent.org/wiki/Download `org.deluge-torrent.Deluge`
:: Nicotine+ (Soulseek client) Plus http://nicotine-plus.sourceforge.net 
:: Owncloud http://owncloud.org/ `com.owncloud.OwnCloudClient`
:: win-sshfs https://code.google.com/p/win-sshfs/downloads/list
:: WinSCP http://winscp.net/eng/docs/screenshots `net.winscp.WinSCP`
:: Marble http://marble.kde.org/
:: TOR Browser bundle https://www.torproject.org/projects/torbrowser.html.en
:: Peerblock http://www.peerblock.com/releases
:: Youtube-DL GUI https://github.com/MrS0m30n3/youtube-dl-gui `youtube-dl-gui`
:: DNSCrypt for Windows https://dnscrypt.org/#dnscrypt-windows
:: 
:: ## Audio/video playback/conversion
:: 
:: VLC http://www.videolan.org/ `com.videolan.VLCMediaPlayer64`
:: Audacious http://audacious-media-player.org/download `audacious`
:: QuodLibet https://quodlibet.readthedocs.org/en/latest/ `quod-libet`
:: Combined Community Codec Pack http://www.cccp-project.net/download.php?type=cccp `cccp64`
:: OGG Codecs https://www.xiph.org/downloads/ `ogg-codecs`
:: Electricsheep http://electricsheep.org/download `org.electricsheep.ElectricSheep`
:: CDex http://cdexos.sourceforge.net/
:: WinFF http://winff.org/html_new/ `winff64`
:: Kodi http://kodi.tv/download/
:: 
:: ## Audio/video editing
:: 
:: Audacity http://audacity.sourceforge.net/?lang=fr `net.sourceforge.audacity.Audacity ar.com.buanzo.lame.LameForAudacity`
:: Mixx http://mixxx.org/ `mixxx`
:: AviDemux http://avidemux.berlios.de/download.html `net.sourceforge.avidemux.Avidemux64`
:: VirtualDub http://www.virtualdub.org/ `org.virtualdub.VirtualDub64`
:: Handbrake http://handbrake.fr/ `fr.handbrake.HandBrake64`
:: Blender http://www.blender.org/ `org.blender.Blender64`
:: Picard http://wiki.musicbrainz.org/PicardTagger 
:: mp3tag http://www.mp3tag.de/en/
:: Open Broadcaster Software http://obsproject.com `open-broadcaster-software`
:: Ardour https://ardour.org/
:: 
:: ## Graphics
:: 
:: GIMP http://www.gimp.org/downloads/ `org.gimp.Gimp`
:: GPS Gimp Paint Studio https://code.google.com/p/gps-gimp-paint-studio/
:: Imagemagick http://www.imagemagick.org/script/index.php
:: Inkscape http://inkscape.org/screenshots/index.php?lang=en
:: Scribus http://scribus.net/canvas/About
:: Tiled http://www.mapeditor.org/ `tiled`
:: IrfanView http://www.irfanview.com/
:: Dia http://www.dia-installer.de/ `org.gnome.live.dia.Dia`
:: LibreCAD http://librecad.org/cms/home.html
:: Sweet Home 3D http://www.sweethome3d.com/fr/index.jsp `com.sweethome3d.SweetHome3D com.sweethome3d.SH3DContributions com.sweethome3d.SH3DKatorLega com.sweethome3d.SH3DLucaPresidente com.sweethome3d.SH3DReallusion com.sweethome3d.SH3DScopia com.sweethome3d.SH3DTrees`
:: 
:: ## Misc
:: 
:: 7-Zip http://www.7-zip.org/download.html `org.7-zip.SevenZIP64 com.googlecode.windows-package-manager.NpackdInstallerHelper`
:: F.lux http://justgetflux.com `f.lux`
:: InfraRecorder http://infrarecorder.org/?page_id=5 `org.infrarecorder.InfraRecorder64`
:: Duplicate Files Finder http://doubles.sourceforge.net/ `duplicate-files-finder`
:: Rainmeter http://rainmeter.net/cms/
:: Zint Barcode Generator http://zint.github.com/
:: Synergy http://synergy-project.org/
:: Javar Runtime Environment `com.oracle.JRE`
:: 
:: ## System utilities
:: 
:: Microsoft Security Essentials http://windows.microsoft.com/fr-FR/windows/products/security-essentials `com.microsoft.SecurityEssentials64`
:: Spybot Search & Destroy http://www.safer-networking.org/fr/ `org.safer-networking.SpyBotSearchAndDestroy`
:: EMET http://technet.microsoft.com/en-us/security/jj653751 `com.microsoft.DotNetRedistributable emet`
:: NirLauncher http://launcher.nirsoft.net/ `net.nirsoft.Launcher`
:: SysInternals Suite http://technet.microsoft.com/en-us/sysinternals/bb842062.aspx `sysinternals-suite`
:: Gow https://github.com/bmatzelle/gow/wiki `com.github.bmatzelle.Gow`
:: Open Hardware Monitor http://openhardwaremonitor.org/ `open-hardware-monitor`
:: BleachBit https://bleachbit.sourceforge.net `bleachbit`
:: WinCDEmu http://wincdemu.sysprogs.org/download/ `org.sysprogs.WinCDEmu64`
:: Universal USB Installer http://www.pendrivelinux.com/universal-usb-installer-easy-as-1-2-3/ `universal-usb-installer`
:: Recuva https://www.piriform.com/recuva
:: Testdisk/Photorec http://www.cgsecurity.org/wiki/PhotoRec `org.cgsecurity.testdisk.TestDisk64`
:: Ext2fsd http://sourceforge.net/projects/ext2fsd/files/
:: LibreCrypt https://github.com/t-d-k/LibreCrypt
:: WSUS Offline Updater http://www.wsusoffline.net/ `wsus-offline-updater`
:: Process Explorer https://technet.microsoft.com/en-us/sysinternals/bb896653.aspx `com.microsoft.ProcessExplorer`
:: VirtualBox https://www.virtualbox.org/ `org.virtualbox.virtualbox64`
:: Speccy https://www.piriform.com/speccy
:: WinDirStat http://windirstat.info/ `info.windirstat.WinDirStat`
:: PWGen http://pwgen-win.sourceforge.net/ `pwgen`
:: Free File Renamer http://sourceforge.net/projects/freefilerenamer `net.sourceforge.FreeFileRenamer`
:: win32diskimager http://sourceforge.net/projects/win32diskimager/ `win32-disk-imager`
:: resource hacker http://www.angusj.com/resourcehacker/ `com.angusj.ResourceHacker`
:: CrystalDiskInfo https://crystalmark.info/software/CrystalDiskInfo/index-e.html `crystaldiskinfo`
:: 
:: ## Development
:: 
:: Sublime Text http://www.sublimetext.com/ `sublime-text64`
:: Notepad++ http://www.notepad-plus-plus.org/ `notepadpp64`
:: Console2 http://sourceforge.net/projects/console/ `net.sourceforge.console.Console`
:: DOS Find And Replace Text http://sourceforge.net/projects/fart-it
:: Meld http://meldmerge.org/ `meld`
:: WinPCap https://www.winpcap.org/ & Wireshark https://www.wireshark.org/
:: PuTTY http://www.putty.org/ `uk.org.greenend.chiark.sgtatham.Putty`
:: Github (+git CLI) `github`
:: Git Extensions http://gitextensions.github.io/
:: Twine https://twinery.org/ `com.twinery.twine64`
:: 
:: ## Games
:: 
:: PCSX2 https://github.com/PCSX2/pcsx2 `pcsx2`
:: SaveGameBackup.net http://sourceforge.net/projects/savegamebackup/ `savegamebackup.net`
:: 
:: ###################################################################
