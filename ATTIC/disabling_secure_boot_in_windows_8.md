> disabling secure boot in windows 8

> * In start menu, type `UEFI` or `BIOS` and click on the settings list.
> * Click on startup options. You should now be in general settings, scroll to the bottom of the right pane and click on the `restart` button below advanced boot.
> * Now go to `Troubleshoot -> Advanced Options > UEFI Firmware Settings`, and click `restart`. This will bring you to your UEFI firmware panel (UEFI's controls akin to BIOS).
> * Go to `Main` and set a Supervisor password, this will allow for advanced security settings.
> * Go to `Security` and **disable secure boot**.
> * Go to `boot order` and put whatever device has your linux image on it first, or if your firmware has such an option, turn on `legacy BIOS emulation` to get the typical BIOS screen when your computer boots.
> * Save and exit, you should now be able to safely install your distribution.