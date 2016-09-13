##PAPermissions

PAPermissions is a fully customizable and ready-to-run library to handle permissions through a ViewController

Right now it supports out of the box permissions for:
- Bluetooth
- Location
- Notifications
- Microphone
- Camera
- Custom

**NB: PAPermissions is written in Swift 2.2, if you are looking for the Swift 3 version of it, please check the [Swift3 branch](https://github.com/pascalbros/PAPermissions/tree/Swift3) **

![](./ReadmeResources/PAPermissions1.gif)
![](./ReadmeResources/PAPermissions2.gif)
![](./ReadmeResources/PAPermissions3.gif)
###Compatibility

PAPermissions requires iOS8+, compatible with both Swift 2/3 and Objective-C based projects

###Screenshots

It can be used with a plain background color
![](./ReadmeResources/Screen1.png)

Or with a background image
![](./ReadmeResources/Screen2.png)

###How it works

Create a new UIViewController, inherit from *PAPermissionsViewController* and write:

```
	let microphoneCheck = PAMicrophonePermissionsCheck()
	let cameraCheck = PACameraPermissionsCheck()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Custom settings
		self.locationCheck.requestAlwaysAuthorization = true
		
		
		let permissions = [
	          PAPermissionsItem.itemForType(.Microphone, reason: "Required to hear your beautiful voice")!,
					  PAPermissionsItem.itemForType(.Camera, reason: "Required to shoot awesome photos")!]
		
		let handlers = [
						PAPermissionsType.Microphone.rawValue: self.microphoneCheck,
						PAPermissionsType.Camera.rawValue: self.cameraCheck]
		self.setupData(permissions, handlers: handlers)

		self.titleText = "My Awesome App"
		self.detailsText = "Please enable the following"
	}
		
```

That's it!

README not finished yet...
