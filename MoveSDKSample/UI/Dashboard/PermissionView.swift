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

struct PermissionView: View {
	@StateObject var locationPermission: LocationPermission
	@StateObject var motionPermission: MotionPermission
	@StateObject var notificationPermission: NotificationPermission

	var body: some View {
		VStack(alignment: .leading, spacing: 16.0) {
			Text("subtit_permissions")
				.font(.moveHeadlineBig)
			Text("txt_permissions")
				.foregroundColor(.moveSecondary)
				.font(.footnote)

			CellView(permission: locationPermission, title: "alert_location", description: "alert_loctext")

			CellView(permission: motionPermission, title: "alert_motion", description: "alert_mottext")

			CellView(permission: notificationPermission, title: "alert_messages", description: "alert_mestext")

		}
		.padding(16.0)
	}
}

struct PermissionView_Previews: PreviewProvider {
	static var previews: some View {
		PermissionView(
			locationPermission: LocationPermission(),
			motionPermission: MotionPermission(),
			notificationPermission: NotificationPermission()
		)
	}
}
