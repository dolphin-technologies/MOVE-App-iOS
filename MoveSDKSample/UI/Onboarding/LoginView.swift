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

struct LoginView: View {
	@EnvironmentObject var appModel: AppModel

	@State private var checkedTermsOfUse = false
	@State private var checkedDataPrivacy = false
	@State private var presentedTermsOfUse = false
	@State private var presentedDataPrivacy = false

	@State private var email = ""
	@State private var password = ""

	@State private var needsValidation = false

	var body: some View {
		VStack(spacing: 20) {
			Text("tit_doplhin_move")
				.font(.moveTitle)
				.foregroundColor(Color.movePrimary)
			Text("txt_login_welcometext")
				.multilineTextAlignment(.center)
				.font(.textMedium)
				.foregroundColor(Color.moveSecondary)
			ZStack(alignment: .top) {
				RoundedRectangle(cornerRadius: 10)
					.fill(Color.background2)
				VStack(alignment: .leading, spacing: 20) {
					InputField(value: $email, label: "lbl_your_email", placeholder: "placeholder_email", validation: checkValid, validate: $needsValidation, contentType: .username)

					InputField(value: $password, label: "lbl_your_password", placeholder: "your_move_password", isSecure: true, validation: checkValid, validate: $needsValidation, contentType: .password)

					Checkbox(isChecked: $checkedTermsOfUse, label: "lbl_accept", link: "lnk_terms_of_use") {
						WebSheet(title: "tit_terms_of_use", path: "url_termsofuse")
					}

					Checkbox(isChecked: $checkedDataPrivacy, label: "lbl_privacy", link: "lnk_privacy_policy") {
						WebSheet(title: "tit_data_privacy", path: "url_privacy")
					}

					Button("tit_login") {
						login()
					}
					.buttonStyle(MoveButtonStyle())
				}
				.padding(16.0)
				.font(.label)
				.foregroundColor(Color.movePrimary)
			}
			.fixedSize(horizontal: false, vertical: true)
			NavigationLink("lnk_dont_have_account") {
				RegistrationView()
			}
			.buttonStyle(MoveBottomButtonStyle())
			NavigationLink("lnk_forgot_password_q") {
				ForgotPasswordView()
			}
			.buttonStyle(MoveBottomButtonStyle())
			Spacer()
		}
		.padding(16.0)
		.navigationBarTitle("tit_login", displayMode: .inline)
    }

	func checkValid(_ value: String) -> String {
		return value.isEmpty ? "err_field_required" : ""
	}

	func login() {
		needsValidation = true
		let emailError = checkValid(email)
		let passwordError = checkValid(password)

		if emailError.isEmpty, passwordError.isEmpty {

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
					try await AppManager.shared.login(email: email, password: password)
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
