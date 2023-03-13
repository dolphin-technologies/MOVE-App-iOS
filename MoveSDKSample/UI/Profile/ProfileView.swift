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

struct ProfileView: View {
	@EnvironmentObject var appModel: AppModel
	@EnvironmentObject var messageCenter: MessageCenterModel
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@StateObject var profile = ProfileModel()

	@State private var needsValidation = false
	@State private var needsPassword = false
	@State private var askLogout = false

	var body: some View {
		ScrollView {
			VStack(spacing: 15) {
				ZStack(alignment: .top) {
					RoundedRectangle(cornerRadius: 10)
						.fill(Color.background2)
					VStack(alignment: .leading, spacing: 20) {
						VStack(alignment: .leading, spacing: 20) {
							GenderPicker(value: $profile.gender, label: "txt_ident")
							InputField(value: $profile.firstname, label: "lbl_your_firstname", placeholder: "placeholder_first_name", validation: checkValid, validate: $needsValidation, required: true)

							InputField(value: $profile.lastname, label: "lbl_your_lastname", placeholder: "placeholder_last_name", validation: checkValid, validate: $needsValidation, required: true)

							InputField(value: $profile.email, label: "lbl_your_email", placeholder: "placeholder_email", validation: checkEmailValid, validate: $needsValidation, required: true)

							InputField(value: $profile.phonennumber, label: "lbl_your_cell", placeholder: "placeholder_mobile")

							InputField(value: $profile.company, label: "lbl_company_name", placeholder: "placeholder_company")
						}

						if needsPassword {
							Divider()

							VStack(alignment: .leading, spacing: 20) {
								InputField(value: $profile.password, label: "lbl_password", placeholder: "your_move_password", isSecure: true, validation: checkValid, validate: $needsValidation, required: true)
							}
						}

						Button("btn_save") {
							save()
						}
						.buttonStyle(MoveButtonStyle())
						Button("btn_logout") {
							askLogout = true
						}
						.alert(isPresented: $askLogout) {
							Alert(title: Text(""),
								  message: Text("hint_logout_warning"),
								  primaryButton: .default(Text("btn_confirm"), action: logout),
								  secondaryButton: .cancel(Text("btn_cancel")))
						}
						.buttonStyle(MoveButtonStyle())
					}
					.onChange(of: profile.email) { newValue in
						needsPassword = profile.isEmailChanged
					}
					.padding(16.0)
					.font(.label)
					.foregroundColor(Color.movePrimary)
				}
				.fixedSize(horizontal: false, vertical: true)
				.padding(16.0)

				NavigationLink("lnk_change_password") {
					ChangePasswordView()
				}
				.buttonStyle(MoveBottomButtonStyle())

				NavigationLink("lnk_delete_account") {
					DeleteProfileView()
				}
				.buttonStyle(MoveBottomButtonStyle())
				Spacer()
			}
		}
		.frame(minHeight: 0, maxHeight: .infinity)
		.navigationBarTitle("tit_my_profile", displayMode: .inline)
		.navigationBarBackButtonHidden()
		.toolbar {
			NavigationToolbar {
				self.presentationMode.wrappedValue.dismiss()
			}
			MessageToolbar(messageCenter: messageCenter)
		}
		.onAppear() {
			appModel.isLoading = true
			Task {
				do {
					try await profile.load()
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
		.accentColor(.title)
    }

	func checkValid(_ value: String) -> String {
		return value.isEmpty ? "err_required_fields" : ""
	}

	func checkEmailValid(_ value: String) -> String {
		if value.isEmpty {
			return "err_required_fields"
		} else if value.isValidEmail {
			return ""
		} else {
			return "err_invalid_email"
		}
	}

	func logout() {
		appModel.isLoading = true
		Task {
			await AppManager.shared.requestLogout()
			DispatchQueue.main.async {
				appModel.isLoading = false
			}
		}
	}

	func save() {
		needsValidation = true

		let firstnameError = checkValid(profile.firstname)
		let lastnameError = checkValid(profile.lastname)

		let emailError = checkEmailValid(profile.email)
		let _ = checkValid(profile.password)

		if
			firstnameError.isEmpty,
			lastnameError.isEmpty,
			emailError.isEmpty {

			appModel.isLoading = true
			Task {
				do {
					let message = try await profile.patch()
					DispatchQueue.main.async {
						appModel.isLoading = false
						appModel.alert = .complete(message: message)
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
			.environmentObject(AppModel())
			.environmentObject(MessageCenterModel())
    }
}
