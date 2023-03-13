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

struct RegistrationView: View {
	@EnvironmentObject var appModel: AppModel
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@State private var checkedTermsOfUse = false
	@State private var checkedDataPrivacy = false

	@State private var firstname = ""
	@State private var lastname = ""

	@State private var gender = -1
	@State private var email = ""
	@State private var password = ""
	@State private var repeatPassword = ""
	@State private var phone = ""
	@State private var company = ""

	@State private var needsValidation = false

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {
				VStack(alignment: .center, spacing: 20) {
					Image("InternetOfThings")
						.padding(.vertical, 30.0)
					Text("tit_reg")
						.multilineTextAlignment(.center)
						.font(.moveTitle)
						.foregroundColor(Color.movePrimary)
					Text("txt_plsreg")
						.multilineTextAlignment(.center)
						.font(.textMedium)
						.foregroundColor(Color.moveSecondary)
					Spacer().frame(height: 10)
					Divider()
				}
				Text("txt_pls_register_or_login")
					.font(.moveHeadline)
					.foregroundColor(Color.movePrimary)
				ZStack(alignment: .top) {
					RoundedRectangle(cornerRadius: 10)
						.fill(Color.background2)
					VStack(alignment: .leading, spacing: 20) {
						VStack(alignment: .leading, spacing: 20) {
							GenderPicker(value: $gender, label: "txt_ident")
							InputField(value: $firstname, label: "lbl_your_firstname", placeholder: "placeholder_first_name", validation: checkValid, validate: $needsValidation, required: true)

							InputField(value: $lastname, label: "lbl_your_lastname", placeholder: "placeholder_last_name", validation: checkValid, validate: $needsValidation, required: true)

							InputField(value: $email, label: "lbl_your_email", placeholder: "placeholder_email", validation: checkEmailValid, validate: $needsValidation, required: true, contentType: .username)

							InputField(value: $phone, label: "lbl_your_cell", placeholder: "placeholder_mobile")

							InputField(value: $company, label: "lbl_company_name", placeholder: "placeholder_company")
						}

						Divider()

						VStack(alignment: .leading, spacing: 20) {
							InputField(value: $password, label: "lbl_choose_password", placeholder: "placeholder_choose_password", isSecure: true, validation: checkPasswordValid, validate: $needsValidation, required: true, contentType: .password)

							InputField(value: $repeatPassword, label: "lbl_repeat_password", placeholder: "placeholder_repeat_password", isSecure: true, validation: checkPasswordRepeatValid, validate: $needsValidation, required: true)
						}

						Divider()

						VStack(alignment: .leading, spacing: 20) {
							Checkbox(isChecked: $checkedTermsOfUse, label: "lbl_accept", link: "lnk_terms_of_use") {
								WebSheet(title: "tit_terms_of_use", path: "url_termsofuse")
							}

							Checkbox(isChecked: $checkedDataPrivacy, label: "lbl_privacy", link: "lnk_privacy_policy") {
								WebSheet(title: "tit_data_privacy", path: "url_privacy")
							}
						}
						Button("btn_register") {
							register()
						}
						.buttonStyle(MoveButtonStyle())
					}
					.padding(16.0)
					.font(.label)
					.foregroundColor(Color.movePrimary)
				}
				.fixedSize(horizontal: false, vertical: true)
				Button("lnk_existing_account") {
					presentationMode.wrappedValue.dismiss()
				}
				.buttonStyle(MoveBottomButtonStyle())
				Spacer()
			}
			.padding(16.0)
			.navigationBarTitle("tit_register", displayMode: .inline)
			.navigationBarBackButtonHidden()
			.toolbar {
				NavigationToolbar {
					self.presentationMode.wrappedValue.dismiss()
				}
			}
			.accentColor(.title)
		}
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
		} else if password == value {
			return ""
		} else {
			return "err_password_mismatch"
		}
	}

	func register() {
		needsValidation = true
		let firstnameError = checkValid(firstname)
		let lastnameError = checkValid(lastname)

		let emailError = checkEmailValid(email)
		let passwordError = checkPasswordValid(password)
		let repeatPasswordError = checkPasswordRepeatValid(repeatPassword)

		if
			firstnameError.isEmpty,
			lastnameError.isEmpty,
			emailError.isEmpty,
			passwordError.isEmpty,
			repeatPasswordError.isEmpty,
			password == repeatPassword,
			gender != -1 {

			if !checkedTermsOfUse {
				appModel.alert = .error(message: "err_tou_not_accepted")
				return
			}

			if !checkedDataPrivacy {
				appModel.alert = .error(message: "err_dp_not_accepted")
				return
			}

			appModel.isLoading = true
			Task {
				do {
					try await AppManager.shared.register(gender: gender, firstname: firstname, lastname: lastname, phone: phone, company: company, email: email, password: password)
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

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
