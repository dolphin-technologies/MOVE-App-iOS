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

import BackgroundTasks
import FirebaseCore
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

	// MARK: Application Launch
	/* the SDK needs to be initialized explicitly at launch */

	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

		/* The initializationAPI must be executed before didFinishLaunchingWithOptions returns. We recommend calling it in willFinishLaunchingWithOptions. */
		
		SDKManager.shared.initSDK(withOptions: launchOptions)
		
		return true
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		registerBackgroundTask(application: application)
		FirebaseApp.configure()
		RemoteConfiguration.setup()

		return true
	}

	// MARK: Push Notification Setup
	/* the user will be notified of succesfully processed trips by our backend via push notifications */

	func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let tokenString = deviceToken.map { String(format: "%02hhx", $0) }.joined()
		print("token: \(tokenString)")
		Task {
			do {
				try await AppManager.shared.setPushToken(tokenString)
			} catch AppError.logout {
				DispatchQueue.main.async {
					AppManager.shared.errorMessage = "\(AppError.logout)"
				}
			} catch {
			}
		}
	}

	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
		do {
			let newData = try await MessageCenterModel.shared?.fetch() ?? false
			return newData ? .newData : .noData
		} catch AppError.logout {
			DispatchQueue.main.async {
				AppManager.shared.errorMessage = "\(AppError.logout)"
			}
			return .failed
		} catch {
			return .failed
		}
	}

	// MARK: Background fetch
	/*
	 using background tasks presents an additional option to make the app wake up at periodic times
	 this ensures consistency of data transfer for the SDK, such as motion activities, sdk status, or other data that wasn't uploaded due to app suspension
	 */

	let backgroundRefreshIdentifier = "in.dolph.sdk.test.task.refresh"
	let backgroundRefreshInterval: TimeInterval = 60 * 60 * 4 /// 4h

	func registerBackgroundTask(application: UIApplication) {
		BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundRefreshIdentifier, using: nil) { task in
			SDKManager.shared.performFetch { result in
				task.setTaskCompleted(success: result != .failed)
			}
			self.scheduleBackgroundFetch(application: application)
		}

		scheduleBackgroundFetch(application: application)

#if targetEnvironment(simulator)
		/// Fallback to old background fetch implementation
		application.setMinimumBackgroundFetchInterval(backgroundRefreshInterval)
#endif
	}

	func scheduleBackgroundFetch(application: UIApplication) {
		let request = BGAppRefreshTaskRequest(identifier: backgroundRefreshIdentifier)
		request.earliestBeginDate = Date(timeIntervalSinceNow: backgroundRefreshInterval)
		do {
			try BGTaskScheduler.shared.submit(request)
			print("background refresh scheduled")
			return
		} catch {
			print("Couldn't schedule app refresh \(error.localizedDescription)")
		}
	}

	/// Fallback to old background fetch implementation
	func application(_: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		SDKManager.shared.performFetch(completionHandler: completionHandler)
	}
}

