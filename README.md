# winget-intune-win32
## About
Repository containing examples of how to use winget from Intune, also in system context.



## Disclaimer
* Files and info in this repo is provided as is. I'm not responsible for what you decide to push to your clients.
* I'm not good at git. Feel free to commit changes, but I might struggle doing git right. Bear with me.
* If logic in this repo breaks, I do not commit to fix it in a timely manner.



## Background
After I saw [rothgecw](https://github.com/rothgecw) had found of that [Winget-cli can run from System context](https://github.com/microsoft/winget-cli/discussions/962#discussioncomment-1561274), I started thinking about how that would be usefull from Intune.



## Basic idea
### What I want
#### Set and forget Win32 packages for both install and updates
Use Winget to create logic in Intune that will handle both install and upgrades.
* Set and forget, I don't want to maintain client applications in Intune.
* Control, I don't want to run ```winget upgrade --all``` because it also upgrades things like Office ProPlus.

#### Only for apps that don't have working auto update logic
Only for apps that either does not autoupgrade by itself, or autoupgrade requires admin permissions.
* Excludes:
  * Apps in system context that auto updates using a service running as SYSTEM
    * Adobe Acrobat Reader DC
	* Google Chrome
	* Mozilla Firefox
  * Microsoft Store UWP apps
  * Apps in user context that auto updates
    * 1Password
	* Microsoft Visual Studio Code (User)
* Includes:
  * 7-Zip
  * Microsoft PowerToys
  * Microsoft Visual Studio Code
  * Notepad++

Apps not available in Microsoft Store that auto updates though, will still be nice to install using Winget. But then skip creating upgrade logic.

#### Don't reinvent the wheel
Piggyback others work.
* Microsoft [winget-cli](https://github.com/microsoft/winget-cli)
* Microsoft [winget-pkgs](https://github.com/microsoft/winget-pkgs)
* Microsoft [Win32 Content Prep Tool](https://github.com/Microsoft/Microsoft-Win32-Content-Prep-Tool)
* [Oliver Kieselbach](https://oliverkieselbach.com/) [IntuneWinAppUtilDecoder](https://github.com/okieselbach/Intune/tree/master/IntuneWinAppUtilDecoder)


### How it works
* Use a dummy *.intunewin containing nothing but a empty text file.
* Create two Win32 packages per app you want to have in Intune installed with Winget-cli.
  * One being available to install from Company Portal, where:
    * Install command uses winget-cli to get newest app available.
	* Detection rule is static, not checking version.
	  * If new version is detected in this package, Company Portal will say that app install failed.
	    * Maybe Company Portal can handle this in the future?
  * One being required, where:
    * Requirement rules requires app to be installed already.
	  * NB: If you don't want to interrupt the end user, make sure to add logic to requirement rule that does keep the upgrade from running if for instance process X and Y are running.
	* Detection rule uses winget-cli to detect if newer version is available.


### Remember
* Observe that I have different detection logic and assignment type, given these three different scenarios
  * Install
  * Upgrade
  * Dependency


## Future ideas
* Create single script per context (user, system) for upgrades.
  * PSADT, serviceui.exe and toast notifications for showing users notifications when logic runs from system context
    * https://www.anoopcnair.com/use-serviceui-with-intune-to-bring-system-process-to-interactive-mode/
  * Host manifest of what apps to upgrade in a storage account maybe?
    * Never use "winget upgrade --all".
