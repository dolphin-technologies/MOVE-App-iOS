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

struct ForgotPasswordView: View {
	@EnvironmentObject var appModel: AppModel
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@State private var email = ""
	@State private var needsValidation = false

	var body: some View {
		VStack(spacing: 20) {
			Text("lbl_password")
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
					InputField(value: $email, label: "lbl_your_email", placeholder: "placeholder_email", validation: checkEmailValid, validate: $needsValidation)

					Button("btn_ok") {
						submit()
					}
				}
				.padding(16.0)
				.font(.label)
				.foregroundColor(Color.movePrimary)
			}
			.buttonStyle(MoveButtonStyle())
			.fixedSize(horizontal: false, vertical: true)
			Spacer()
		}
		.padding(20.0)
		.navigationBarTitle("tit_forgot_password", displayMode: .inline)
		.navigationBarBackButtonHidden()
		.toolbar {
			NavigationToolbar {
				self.presentationMode.wrappedValue.dismiss()
			}
		}
		.accentColor(.title)
	}

	func checkEmailValid(_ value: String) -> String {
		if value.isEmpty {
			return "err_field_required"
		} else if value.isValidEmail {
			return ""
		} else {
			return "err_invalid_email"
		}
	}

	func submit() {
		needsValidation = true
		let emailError = checkEmailValid(email)

		if emailError.isEmpty {
			appModel.isLoading = true
			Task {
				do {
					try await AppManager.shared.requestForgotPassword(email: email)
					DispatchQueue.main.async {
						appModel.isLoading = false
						appModel.alert = .complete(message: "val_forgot_password")
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

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
