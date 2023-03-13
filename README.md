# Dolphin MOVE App

A sample application that uses the Dolphin MOVE SDK. 
This project could be a great starter project for new apps, else AppManager.swift file is a recommended starting point for embedding the SDK in already existing projects.

## App cycle goes as follows:

On app initialization.
- Init the SDK

#### Login/Register User
- Login a persisted user on the SDK.

#### Toggle Activation switch: ON
- app will automatically start SDK services using ‘startAutomaticDetection’ API
- the services will start running once they have the necessary permissions.

#### Launch from Background
- It's now possible for the app to launch from the background by itself.

#### Toggle Activation switch: OFF
- Stops the SDK services using ‘stopAutomaticDetection’ API.

#### Logout
- Shuts down the SDK

The sample app persists the SDK activation toggling State is persisted for future initializations.

For simplicity, the sample app uses SwiftUI to define app views and Combine to subscribe and render MOVE SDK listeners changes. 

## To run this project:

1. Request a product API Key by contacting Dolphin MOVE.
2. From finder, open the repository's workspace MoveSDKSample.xcodeproj with Xcode.
3. In Project settings General tab, change the Bundle Identifier to a unique one.
4. Replace the `GoogleService-Info.plist` with your own.
5. Clean, build and run the application on your device

Reference: MOVE iOS SDK [documentation](https://docs.movesdk.com/).

## Starting Point:

### SDK Setup:

#### Authorization

After contacting us and getting a product API key, use it to fetch a MoveAuth from the Move Server. MoveAuth object will be passed to the SDK on setup (login) and be used by the SDK to authenticate its services.


#### Configuration

MoveConfig allows host apps to configure which of the licensed Move services should be enabled. It could be based on each user preference or set from a remote server. MoveConfig will be passed to the SDK on setup (login). All permissions required for the requested configurations must be granted.

#### State Listener:

The host app is expected to set its `SDKStateListener` before initializing the SDK to intercept the MoveSDKState changes caused by calling the `initialize` API.

#### SDK Initialization:

The SDK `initialization` API must be executed before the App delegate's method  `didFinishLaunchingWithOptions` returns. We recommend calling it in `willFinishLaunchingWithOptions`. Check in the app delegate  `SDKManager.shared.initSDK(withOptions: launchOptions)` 

## Support
[info@dolph.in](mailto://info@dolph.in)
 
## License

The contents of this repository are licensed under the
[Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
