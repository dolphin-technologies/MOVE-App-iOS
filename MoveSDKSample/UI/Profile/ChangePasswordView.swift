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

struct ChangePasswordView: View {
	@EnvironmentObject var appModel: AppModel
	@EnvironmentObject var messageCenter: MessageCenterModel
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@State var password: String = ""
	@State var newPassword: String = ""
	@State var repeatPassword: String = ""

	@State private var needsValidation = false

	var body: some View {
		VStack {
			ScrollView {
				ZStack(alignment: .top) {
					RoundedRectangle(cornerRadius: 10)
						.fill(Color.background2)
					VStack(alignment: .leading, spacing: 20) {
						VStack(alignment: .leading, spacing: 20) {
							InputField(value: $password, label: "lbl_current_password", placeholder: "your_move_password", isSecure: true, validation: checkValid, validate: $needsValidation, required: true, contentType: .password)

							InputField(value: $newPassword, label: "lbl_set_new_password", placeholder: "placeholder_choose_password", isSecure: true, validation: checkPasswordValid, validate: $needsValidation, required: true, contentType: .newPassword)

							InputField(value: $repeatPassword, label: "lbl_repeat_password", placeholder: "placeholder_repeat_password", isSecure: true, validation: checkPasswordRepeatValid, validate: $needsValidation, required: true)

							Button("btn_save") {
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
				.padding(16.0)
				Spacer()
			}
		}
		.frame(minHeight: 0, maxHeight: .infinity)
		.navigationBarTitle("tit_change_password", displayMode: .inline)
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
		return value.isEmpty ? "err_field_required" : ""
	}

	func checkPasswordValid(_ value: String) -> String {
		if value.isEmpty {
			return "err_required_fields"
		} else if value.isValidPassword {
			return ""
		} else {
			return "err_password_policy_error"
		}
	}

	func checkPasswordRepeatValid(_ value: String) -> String {
		if value.isEmpty {
			return "err_required_fields"
		} else if newPassword == value {
			return ""
		} else {
			return "err_password_mismatch"
		}
	}

	func submit() {
		needsValidation = true
		let passwordError = checkValid(password)
		let newPasswordError = checkPasswordValid(newPassword)
		let repeatError = checkPasswordRepeatValid(repeatPassword)

		if passwordError.isEmpty, newPasswordError.isEmpty, repeatError.isEmpty, newPassword == repeatPassword {

			appModel.isLoading = true
			Task {
				do {
					try await AppManager.shared.requestChangePassword(old: password, new: newPassword)
					DispatchQueue.main.async {
						appModel.isLoading = false
						appModel.alert = .complete(message: "val_password_reset_success")
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

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
			.environmentObject(MessageCenterModel())
    }
}
