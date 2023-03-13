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

import SwiftUI

import CoreLocation
import CoreMotion

/// Permission management
class Permission: ObservableObject {
	enum Status {
		case unknown
		case denied
		case limited
		case granted
	}

	@Published var status: Status = .unknown

	/// Check permission on startup, if requested
	func checkPermission() {}

	/// Request permission, on user interaction
	func requestPermission() {}
}

/// Location permission management
class LocationPermission: Permission {
	class Delegate: NSObject, CLLocationManagerDelegate {
		weak var delegate: LocationPermission?

		func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
			delegate?.getLocationPermission()
		}
	}

	private let locationManager = CLLocationManager()
	private let locationManagerDelegate = Delegate()

	override init() {
		super.init()
		locationManagerDelegate.delegate = self
		locationManager.delegate = locationManagerDelegate
		getLocationPermission()
	}

	override func requestPermission() {
		locationManager.requestAlwaysAuthorization()
	}

	private func getLocationPermission() {
		let isPrecise = locationManager.accuracyAuthorization == .fullAccuracy ? true : false
		let status = locationManager.authorizationStatus

		switch status {
		case .notDetermined:
			self.status = .unknown
		case .restricted:
			self.status = .denied
		case .denied:
			self.status = .denied
		case .authorizedAlways:
			self.status = isPrecise ? .granted : .denied
		case .authorizedWhenInUse:
			self.status = isPrecise ? .limited : .denied
		@unknown default:
			self.status = .unknown
		}
	}

	override func checkPermission() {
		getLocationPermission()
	}
}

/// Motion Activities permission management
class MotionPermission: Permission {

	let motionManager = CMMotionActivityManager()

	/// Is motion permission requested User defaults key
	private let isPermissionRequestedKey = "isMotionPermissionRequested"

	/// Flag representing if permission toggle is disabled.
	/// a permission that has not been requested will not be automatically checked on startup, as this can trigger an authorization dialog (not in case of location permission)
	private var isPermissionRequested: Bool {
		didSet { UserDefaults.standard.set(self.isPermissionRequested, forKey: self.isPermissionRequestedKey) }
	}

	override init() {
		isPermissionRequested = UserDefaults.standard.bool(forKey: isPermissionRequestedKey)
		super.init()
	}

	override func requestPermission() {
		requestMotionPermission() { status in
			self.get(status: status)
			self.isPermissionRequested = true
			/*
			 motion permission changes will normally terminate the app
			 this is the only case where it doesn't, so the sdk needs to explicitly told to re check the permission here
			 */
			SDKManager.shared.resolveErrors()
		}
	}

	private func requestMotionPermission(_ completion: ((_ result: CMAuthorizationStatus) -> Void)? = nil) {
		motionManager.queryActivityStarting(from: Date(), to: Date(), to: OperationQueue.main) { _, error in
			if error != nil {
				/* Check if permission is granted on simulator to bypass sensors not available error .*/
#if targetEnvironment(simulator)
				completion?(CMMotionActivityManager.authorizationStatus())
#else
				completion?(CMAuthorizationStatus.denied)
#endif
			}
			else {
				completion?(CMAuthorizationStatus.authorized)
			}
		}
	}

	private func get(status: CMAuthorizationStatus) {
		switch status {
		case .notDetermined:
			self.status = .unknown
		case .restricted:
			self.status = .denied
		case .denied:
			self.status = .denied
		case .authorized:
			self.status = .granted
		@unknown default:
			self.status = .unknown
		}
	}

	override func checkPermission() {
		if isPermissionRequested {
			requestMotionPermission() { status in
				self.get(status: status)
			}
		}
	}
}

/// Push Notfications permission management
class NotificationPermission: Permission {

	/// Is motion permission requested User defaults key
	private let isPermissionRequestedKey = "isNotificationPermissionRequested"

	/// Flag representing if permission toggle is disabled.
	/// a permission that has not been requested will not be automatically checked on startup, as this can trigger an authorization dialog (not in case of location permission)
	private var isPermissionRequested: Bool {
		didSet { UserDefaults.standard.set(self.isPermissionRequested, forKey: self.isPermissionRequestedKey) }
	}

	override init() {
		isPermissionRequested = UserDefaults.standard.bool(forKey: isPermissionRequestedKey)
		super.init()
	}

	override func requestPermission() {
		requestNotificationPermission() { status in
			self.status = status ? .granted : .denied
			self.isPermissionRequested = true
		}
	}

	let center = UNUserNotificationCenter.current()
	let options: UNAuthorizationOptions = [.badge, .sound, .alert]

	func requestNotificationPermission(_ completion: @escaping(_ result: Bool) -> Void) {
		center.requestAuthorization(options: options) { success, _ in
			DispatchQueue.main.async {
				UIApplication.shared.registerForRemoteNotifications()
				completion(success)
			}
		}
	}

	override func checkPermission() {
		if isPermissionRequested {
			requestNotificationPermission() { status in
				self.status = status ? .granted : .denied
			}
		}
	}
}
