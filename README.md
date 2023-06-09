## Chocolatey package update notifier designed to run as a service
### Requires gsudo
#### Install via `chocolatey install gsudo` from an elevated session
#
When the script fires it will list all outdated packages and their latest releases and prompt if an update is desired.
![image](https://user-images.githubusercontent.com/46477191/230476935-ead3a2cc-b03a-4d7d-ae87-3a918782db91.png)

Choosing to update will launch an elevated cmd window which will run the command `sudo choco upgrade all`
![image](https://user-images.githubusercontent.com/46477191/230478561-c936cb3f-5e6c-4732-a68a-078b93c980b6.png)

######
This script is designed to be small and simple and will likely never have very complex options such as single package upgrades or select package upgrades.
Such action should be done manually if desired. This scripts sole goal is to notify and prompt for a quick, easy and fast package upgrade.
