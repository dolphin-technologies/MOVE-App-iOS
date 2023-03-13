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

struct CellView: View {
	@StateObject var permission: Permission

	var title: String
	var description: String

    var body: some View {
		VStack(alignment: .leading, spacing: 0.0) {
			HStack(alignment: .center) {
				Text(NSLocalizedString(title, comment: ""))
					.font(.button)
				Spacer()
				Button {
					if permission.status == .unknown {
						permission.requestPermission()
					} else {
						UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
					}
				} label: {
					switch permission.status{
					case .unknown:
						Text("btn_continue")
							.foregroundColor(.movePrimary)
							.padding(EdgeInsets(top: 7.0, leading: 15.0, bottom: 7.0, trailing: 15.0))
							.border(Color.movePrimary, width: 1.0)
					case .denied:
						Text("btn_open_settings")
							.foregroundColor(.movePrimary)
							.padding(EdgeInsets(top: 7.0, leading: 15.0, bottom: 7.0, trailing: 15.0))
							.border(Color.movePrimary, width: 1.0)
					case .limited:
						Text("btn_open_settings")
							.padding(EdgeInsets(top: 7.0, leading: 15.0, bottom: 7.0, trailing: 15.0))
							.foregroundColor(.title)
							.background(Color.buttonPrimary)
					case .granted:
						Text("btn_granted")
							.padding(EdgeInsets(top: 7.0, leading: 15.0, bottom: 7.0, trailing: 15.0))
							.foregroundColor(.title)
							.background(Color.buttonPrimary)
					}
				}
				.disabled(permission.status == .granted)
				.font(.labelSmall)
			}
			.padding(15.0)
			Rectangle()
				.fill(Color.background)
				.frame(height: 1.0)
			Text(NSLocalizedString(description, comment: ""))
				.font(.textMedium)
				.foregroundColor(.moveSecondary)
				.fixedSize(horizontal: false, vertical: true)
				.padding(15.0)
		}
		.background(Color.background2)
		.cornerRadius(10.0)
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
		CellView(permission: LocationPermission(), title: "Location", description: "txt_permissions")
    }
}
