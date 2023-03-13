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

extension String {
	var isValidEmail: Bool {
		/// RFC 5322 http://emailregex.com
		let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
		return predicate.evaluate(with: self)
	}

	var isValidPassword: Bool {
		/// 1 upper, 1 lower, 1 number, 7 characters minimum
		let regex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{7,}$"
		let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
		return predicate.evaluate(with: self)
	}
}

struct InputField: View {
	@Binding var value: String
	@Binding var validate: Bool
	@State var invalid: String = ""

	let contentType: UITextContentType?
	let label: String
	let placeholder: String
	let isSecure: Bool
	let validation: ((String)->(String))?

	init(value: Binding<String>, label: String, placeholder: String, isSecure: Bool = false, validation: ((String)->String)? = nil, validate: Binding<Bool> = .constant(false), required: Bool = false, contentType: UITextContentType? = nil) {
		_value = value
		_validate = validate

		let lbl = NSLocalizedString(label, comment: "")
		self.label = required ? "\(lbl) *" : lbl
		self.placeholder = NSLocalizedString(placeholder, comment: "")
		self.isSecure = isSecure
		self.validation = validation
		self.contentType = contentType
	}

	var body: some View {
		VStack(alignment: .leading) {
			Text(label)
			if isSecure {
				SecureField(placeholder, text: $value)
					.onChange(of: value) {
						invalid = validateField($0)
					}
					.textFieldStyle(MoveTextFieldStyle())
					.textContentType(contentType)
			} else {
				TextField(placeholder, text: $value)
					.onChange(of: value) {
						invalid = validateField($0)
					}
					.textFieldStyle(MoveTextFieldStyle())
					.autocapitalization(.none)
					.autocorrectionDisabled()
					.textContentType(contentType)
			}
			if !invalid.isEmpty {
				Text(NSLocalizedString(invalid, comment: ""))
					.font(.textMedium)
					.foregroundColor(Color.fieldError)
			}
		}
		.onChange(of: validate) { _ in
			invalid = validateField(value)
		}
    }

	func validateField(_ value: String) -> String {
		if validate, let validation = validation {
			return validation(value)
		}

		return ""
	}
}
