# CrackBot2 🤖

<img src="https://user-images.githubusercontent.com/11541888/71923323-1757c800-318d-11ea-9576-3f57273ffb8c.gif" width="100%" />

CrackBot2 is a bash script used to automate decryption of iOS apps.

**NOTE**: for research and reverse engineering purposes only. Do **NOT** use this for piracy.

## Requirements
* macOS (tested on Catalina 10.15.2)
* Jailbroken iOS device (tested on iPhone 6s, iOS 11 and 12)

## Usage
`./bot <iTunes URL>`

## Setup
### Device
* Set device language to English
* Connect the device to your computer and make sure to accept the trust dialog
* Install the following packages from Cydia:
	* OpenSSH
	* bfdecrypt from https://level3tjg.xyz/repo/
	* plutil
	* Open for iOS 11
	* [AutoTouch](https://autotouch.net)
	* [NoAppThinning](https://github.com/n3d1117/NoAppThinning) from https://n3d1117.github.io
	* Activator from https://rpetri.ch/repo
* Make sure you are logged in the App Store, preferably with US account
* Disable password requirement for free apps (Settings -> iTunes & App Store -> Password Settings -> Disable Require Password)
* In bfdecrypt settings, toggle one app on and off (this allows the creation of `com.level3tjg.bfdecrypt.plist` file in `/var/mobile/Library/Preferences`)

### Computer
* Install jq with `brew install jq` (requires [Homebrew](https://brew.sh))
* Install [ios-deploy](https://github.com/ios-control/ios-deploy) with `brew install ios-deploy` (requires [Homebrew](https://brew.sh))
* Connect your jailbroken device with USB
* Enable passwordless root login for your device:
	* `ssh-keygen -t rsa -P '' -f ~/.ssh/YOUR_DEVICE_NAME`
	* `ssh-copy-id -i ~/.ssh/YOUR_DEVICE_NAME.pub root@YOUR_DEVICE_IP` (if needed, install ssh-copy-id with `brew install ssh-copy-id`)
	* You should now be able to connect to your device with `ssh root@YOUR_DEVICE_IP` without entering the password.
	* **NOTE**: I strongly recommend enabling [SSH via USB](https://iphonedevwiki.net/index.php/SSH_Over_USB) so you can connect to your device as `ssh root@localhost -p 2222` 

## Getting started
* Download and install [my fork](https://github.com/n3d1117/bfdecrypt) of [BishopFox's bfdecrypt](https://github.com/BishopFox/bfdecrypt): 
	```bash
	cd ~/downloads/
	curl -L -O "https://github.com/n3d1117/bfdecrypt/raw/master/bfdecrypt.dylib"
	scp bfdecrypt.dylib root@YOUR_DEVICE_IP:/Library/MobileSubstrate/DynamicLibraries/bfdecrypt.dylib
	```
* SSH into your device (`ssh root@YOUR_DEVICE_IP`) and sign the dylib:
	```bash
	ldid -S /Library/MobileSubstrate/DynamicLibraries/bfdecrypt.dylib
	killall backboardd
	```
* Then create needed folders **on device**:
	```bash
	cd /var/mobile/Library/AutoTouch/Scripts && mkdir -p CrackBot2
	```
* Clone this repo on **your computer**:
	```bash
	cd ~/downloads/
	git clone https://github.com/n3d1117/CrackBot2.git
	```
* Copy AutoTouch script to device:
	```bash
	cd ~/downloads/CrackBot2/AutoTouch 
	scp -r appstoredownload.lua images root@YOUR_DEVICE_IP:/var/mobile/Library/AutoTouch/Scripts/CrackBot2
	```
* On your device open AutoTouch, go to `appstoredownload.lua`, click (i) -> Playing settings -> Trigger with activator -> Select `Hold status bar`.
* Open `bot` file with a text editor and, if needed, edit `DEVICE_IP` and `DEVICE_PORT` parameters with yours.
* Done! You can now run the script from your computer:
	```bash
	cd ~/downloads/CrackBot2/ 
	./bot
	```

**NOTE**: Only free apps (or paid ones previously bought) are supported at the moment.

## Credits
* [bfdecrypt](https://github.com/BishopFox/bfdecrypt): Utility to decrypt App Store apps on jailbroken iOS 11.x
* [level3tjg](https://level3tjg.xyz/repo/) for a preference-based bfdecrypt
* [AutoTouch](https://autotouch.net): Record, playback, simulate human touching/pressing, run Lua scripts.
* [Activator](https://rpetri.ch/cydia/activator/beta/): Centralized gestures, button and shortcut management for iOS

## License
Licensed under GNU General Public License v3.0. See [LICENSE](LICENSE) file for further information.
