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

struct DeleteProfileView: View {
	@EnvironmentObject var appModel: AppModel
	@EnvironmentObject var messageCenter: MessageCenterModel
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@State var password: String = ""
	@State private var needsValidation = false

	var body: some View {
		VStack {
			ScrollView {
				VStack(alignment: .leading) {
					Text("hint_delete_warning")
						.font(.textMedium)
						.foregroundColor(Color.moveSecondary)

					ZStack(alignment: .top) {
						RoundedRectangle(cornerRadius: 10)
							.fill(Color.background2)
						VStack(alignment: .leading, spacing: 20) {
							VStack(alignment: .leading, spacing: 20) {
								InputField(value: $password, label: "lbl_password", placeholder: "your_move_password", isSecure: true, validation: checkValid, validate: $needsValidation, required: true)

								Button("lnk_delete_account") {
									submit()
								}
								.buttonStyle(MoveButtonStyle())
							}
						}
						.padding(16.0)
						.font(.label)
						.foregroundColor(Color.movePrimary)
					}
					.fixedSize(horizontal: false, vertical: true)
//					.padding(20.0)
					Spacer()
				}
				.padding(16.0)
			}
		}
		.frame(minHeight: 0, maxHeight: .infinity)
		.navigationBarTitle("tit_delete_account", displayMode: .inline)
		.navigationBarBackButtonHidden()
		.toolbar {
			NavigationToolbar {
				self.presentationMode.wrappedValue.dismiss()
			}
			MessageToolbar(messageCenter: messageCenter)
		}
		.accentColor(.title)
	}

	func checkValid(_ value: String) -> String {
		return value.isEmpty ? "err_required_fields" : ""
	}

	func submit() {
		needsValidation = true
		
		let passwordError = checkValid(password)

		if passwordError.isEmpty {
			appModel.isLoading = true
			Task {
				do {
					try await AppManager.shared.deleteUser(password: password)
					DispatchQueue.main.async {
						appModel.isLoading = false
					}
				} catch {
					DispatchQueue.main.async {
						appModel.isLoading = false
						appModel.alert = .error(message: "\(error)")
					}
				}
			}
		}
	}
}

struct DeleteProfileView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteProfileView()
			.environmentObject(MessageCenterModel())
    }
}
