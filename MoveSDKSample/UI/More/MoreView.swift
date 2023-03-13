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

struct MoreView: View {
	@EnvironmentObject var appModel: AppModel
	@EnvironmentObject var messageCenter: MessageCenterModel
	@StateObject var viewModel: DashboardModel
	@State var helpIsPresented: Bool = false
	@State var showPrivacy: Bool = false
	@State var version: String = Version.versionString

	var body: some View {
		NavigationView {
			VStack {
				VStack(alignment: .leading, spacing: 0.0) {
					NavigationLink("lbl_profile") {
						ProfileView()
					}
					.buttonStyle(MoveNavigationLingStyle())

					WebLink(path: "url_help", title: "tit_infos_help", label: "lbl_inf")
						.buttonStyle(MoveNavigationLingStyle())

					WebLink(path: "url_imprint", title: "tit_imprint_contact", label: "lbl_imp")
						.buttonStyle(MoveNavigationLingStyle())

					WebLink(path: "url_termsofuse", title: "tit_terms_of_use", label: "lbl_tou")
						.buttonStyle(MoveNavigationLingStyle())

					WebLink(path: "url_privacy", title: "tit_data_privacy", label: "lbl_data_privacy")
						.buttonStyle(MoveNavigationLingStyle())
				}
				.frame(maxWidth: .infinity)
				.font(.button)
				.padding([.leading], 16.0)

				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.fill(Color.background2)
					VStack(alignment: .leading, spacing: 10.0) {
						Text("txt_user_name")
						.font(.button)
						VStack(alignment: .leading, spacing: 5.0) {
							HStack {
								Text("txt_user_id")
								Text(appModel.userID ?? "")
							}
							HStack {
								Text("txt_version")
								Text(version)
							}
						}
						.font(.textInfo)
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(16.0)
				}
				.fixedSize(horizontal: false, vertical: true)
				.padding(16.0)
				Spacer()
			}
			.foregroundColor(.movePrimary)
			.navigationBarTitle("tit_more", displayMode: .inline)
			.toolbar {
				MessageToolbar(messageCenter: messageCenter)
			}
			.accentColor(.title)
		}
	}
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
		MoreView(viewModel: DashboardModel())
			.environmentObject(AppModel())
			.environmentObject(MessageCenterModel())
    }
}
