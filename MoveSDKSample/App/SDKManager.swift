/*
 *  Copyright 2023 Dolphin Technologies GmbH
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http:*www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 * /
 */

import Combine
import UIKit
import DolphinMoveSDK

/// Main Interface for managing the MOVE SDK and its services.
class SDKManager {

	/// SDKManager shared instance.
	static let shared = SDKManager()
	
	/// SDK state UI observer
	let statesMonitor = SDKStatesMonitor()

	/**
	SDK activation state
	
	An app level flag representing if the SDK Service should be activated or not.
	Usually this flag will be set:
	- After the user's login and permissions are granted.
	- Or reverted by  `shutdown()` or `stopAutomaticDetection()` when user wants to stop tracking or logs out.

	In this app, this state will be set from toggling in the UI the SDK activation toggle switch.
	*/
	var isSDKStarted: Bool = false {
		didSet {
			/* persist state*/
			UserDefaults.standard.set(isSDKStarted, forKey: "isSDKStarted")
		}
	}
	
	/// MOVE SDK instance
	let moveSDK: MoveSDK = MoveSDK.shared

	init() {
		/* Decode possibly persisted isSDKStarted bool */
		self.isSDKStarted = UserDefaults.standard.bool(forKey: "isSDKStarted")
	}

	/**
	Initiates the MOVE SDK if possible on wake up
	
	#Inits the SDK

	 - will bring the SDK into it's persisted state

	 recommended to call in app delegate's willFinishLaunching
	 make sure this is completed before the app suspends on background launch by either:
	 1. happening on main thread, or
	 2. having a background task to keep the app activated
	*/
	func initSDK(withOptions options: [UIApplication.LaunchOptionsKey: Any]? = nil) {
		print("initialize sdk")
		/* setup listeners for the SDK callbacks */
		moveSDK.setLogListener(sdkLogListener)
		moveSDK.setAuthStateUpdateListener(sdkAuthStateListener)
		moveSDK.setServiceWarningListener(sdkWarningListener)
		moveSDK.setServiceFailureListener(sdkFailureListener)
		moveSDK.setSDKStateListener(sdkStateListener)
		moveSDK.setTripStateListener(sdkTripStateListener)

		/* initialize sdk, will setup persistent SDK state */
		moveSDK.initialize(launchOptions: options)
	}

	/// Toggles MOVE SDK Activation State
	func toggleMoveSDKState() {

		/* Switch on latest state to determine the action */
		switch moveSDK.getSDKState() {
		case .uninitialized:
			self.statesMonitor.state = .uninitialized
		case .running:
			/* Toggle back from running to ready */
			moveSDK.stopAutomaticDetection()
			self.isSDKStarted = false
		case .ready:
			/* Toggle to running the SDK services */
			moveSDK.startAutomaticDetection()
			self.isSDKStarted = true
		}
	}

	/// Resolve errors, generally invoked after motion permission state changes
	func resolveErrors() {
		moveSDK.resolveSDKStateError()
	}
	
	/**
	MOVE SDK user setup.
	
	# Tasks
	
	 1. Prepare MOVE SDK Configurations
	 2. initialize the SDK's shared instance using `setup` API

	 this is called once after login or registration
	*/
	func authenticateSDK(auth: MoveAuth, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {

		/* 1.  setup config for allowed SDK services.
		N.B: Requesting services which are not active on the licensed endpoint will result in config mismatch */
		let config = MoveConfig(detectionService: [.driving([.drivingBehavior, .distractionFreeDriving]), .cycling, .publicTransport, .pointsOfInterest])

		/* 2. Initialize the SDK's shared instance */
		moveSDK.setup(auth: auth, config: config)
	}

	/// Triggers the SDK internal upload queue and reports network errors on failure
	func performFetch(completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		moveSDK.performBackgroundFetch { result in
			print("processed background fetch \(result)")
			completionHandler(result)
		}
	}
}

//MARK:- MOVE SDK Listeners
extension SDKManager {
	
	/**
	Monitors MOVE SDK generated logs.
	Host apps could append those logs to his app analytics or logging tools.
	*/
	func sdkLogListener(_ text: String, _ value: String?) {
		DispatchQueue.main.async {
			self.statesMonitor.logMessage = text
		}
	}

	/// Monitors MOVE SDK Serrvice Warnings
	func sdkWarningListener(_ warnings: [MoveServiceWarning]) {
		DispatchQueue.main.async {
			print("warnings: \(warnings)")
			self.statesMonitor.warnings = warnings
		}
	}

	/// Monitors MOVE SDK Serrvice Failures
	func sdkFailureListener(_ failures: [MoveServiceFailure]) {
		DispatchQueue.main.async {
			print("failures: \(failures)")
			self.statesMonitor.failures = failures
		}
	}

	/// Monitors MOVE SDK Auth State and handles the changes accordingly.
	func sdkAuthStateListener(_ state: MoveAuthState) {
		DispatchQueue.main.async {
			self.statesMonitor.authState = "\(state)"
		}

		switch state {
		case .invalid:
			/* the SDK user was logged out of the SDK */
			AppManager.shared.forceLogout()
		default:
			break
		}
	}

	/// Monitors MOVE SDK  State and handles the changes accordingly.
	func sdkStateListener(_ state: MoveSDKState) {
		/* the SDK state listener handles changes in the SDK state machine */
		DispatchQueue.main.async {
			self.statesMonitor.state = state
		}
	}

	/// Monitors MOVE SDK Trip State.
	func sdkTripStateListener(_ state: MoveTripState) {
		/* this is called when the trip state changes */
		/* idle, driving */
		DispatchQueue.main.async {
			self.statesMonitor.tripState = state
		}
	}

	func shutdown() {
		isSDKStarted = false
		moveSDK.shutDown()
	}
}
