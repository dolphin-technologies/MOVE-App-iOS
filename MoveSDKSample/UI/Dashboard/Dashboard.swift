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
import AlertToast

struct Dashboard: View {
	@EnvironmentObject var messageCenter: MessageCenterModel
	@Environment(\.scenePhase) var scenePhase

	@StateObject var locationPermission = LocationPermission()
	@StateObject var motionPermission = MotionPermission()
	@StateObject var notificationPermission = NotificationPermission()
	@StateObject var viewModel: DashboardModel

	@State private var showGreeting = true

	var body: some View {
		NavigationView {
			VStack(alignment: .leading, spacing: 0) {
				ActivationView(viewModel: viewModel)
				if viewModel.isDriving {
					Text("alert_are_you_driving")
						.font(.textMedium)
						.multilineTextAlignment(.center)
						.foregroundColor(.title)
						.padding(10.0)
						.frame(maxWidth: .infinity)
						.background(RoundedRectangle(cornerRadius: 10.0).fill(Color.warning))
						.padding(15.0)
				}
				ScrollView() {
					VStack(alignment: .leading) {
						PermissionView(locationPermission: locationPermission, motionPermission: motionPermission, notificationPermission: notificationPermission)
					}
				}
			}
			.navigationBarTitle("tit_move", displayMode: .inline)
			.toolbar {
				MessageToolbar(messageCenter: messageCenter)
			}
			.accentColor(.title)
		}
		.onAppear() {
			locationPermission.checkPermission()
			motionPermission.checkPermission()
			notificationPermission.checkPermission()
		}
		.toast(isPresenting: $viewModel.showAlert) {
			AlertToast(type: .error(.red), title: viewModel.sdkListeners.alertError)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		Dashboard(viewModel: DashboardModel())
		.environmentObject(MessageCenterModel())
	}
}
