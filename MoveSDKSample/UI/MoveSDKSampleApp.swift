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

import AlertToast
import SwiftUI

@main
struct MoveSDKSampleApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@StateObject var appManager = AppManager.shared
	@StateObject var appModel = AppModel()

	init() {
		/* setup navigation bar with color gradient */
		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundImage = makeNavigationBarGradientImage()
		appearance.titleTextAttributes = [.foregroundColor: UIColor.title, .font : UIFont.title]
		UINavigationBar.appearance().standardAppearance = appearance
		UINavigationBar.appearance().scrollEdgeAppearance = appearance

		UITabBar.appearance().shadowImage = UIImage()
		UITabBar.appearance().backgroundImage = UIImage()
		UITabBar.appearance().isTranslucent = true
		UITabBar.appearance().backgroundColor = UIColor.tabBar
	}

	@Environment(\.scenePhase) var scenePhase

	var body: some Scene {
        WindowGroup {
			if appModel.userID != nil {
				BaseTabView()
					.environmentObject(appModel)
			} else {
				OnboardingNavigationView()
					.environmentObject(appModel)
			}
        }
    }
}
