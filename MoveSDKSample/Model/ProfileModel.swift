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

class ProfileModel: ObservableObject {
	enum Gender: String {
		case female
		case male
		case diverse

		var intValue: Int {
			switch self {
			case .female: return 0
			case .male: return 1
			case .diverse: return 2
			}
		}

		init(_ value: Int) {
			switch value {
			case 0: self = .female
			case 1: self = .male
			default: self = .diverse
			}
		}

		init(_ value: String?) {
			switch value {
			case "female": self = .female
			case "male": self = .male
			default: self = .diverse
			}
		}
	}

	/// Gender.
	@Published var gender: Int = 0

	/// First name.
	@Published var firstname: String = ""

	/// Last name.
	@Published var lastname: String = ""

	/// Login email address.
	@Published var email: String = ""

	/// Phone number, optional.
	@Published var phonennumber: String = ""

	/// Company, optional.
	@Published var company: String = ""

	/// Password.
	@Published var password: String = ""

	/// Track whether email is being changed.
	var isEmailChanged: Bool {
		prevEmail != email
	}

	private var prevGender: Int = 0
	private var prevFirstname: String = ""
	private var prevLastname: String = ""
	private var prevEmail: String = ""
	private var prevPhonenumber: String = ""
	private var prevCompany: String = ""

	/// Load user data from server.
	/// - throws: network errors
	func load() async throws {
		let contract = try await AppManager.shared.getUser()
		DispatchQueue.main.async {
			self.gender = Gender(contract.gender).intValue
			self.firstname = contract.firstName ?? ""
			self.lastname = contract.lastName ?? ""
			self.email = contract.email ?? ""
			self.phonennumber = contract.phone ?? ""
			self.company = contract.company ?? ""

			self.prevGender = self.gender
			self.prevFirstname = self.firstname
			self.prevLastname = self.lastname
			self.prevEmail = self.email
			self.prevPhonenumber = self.phonennumber
			self.prevCompany = self.company
		}
	}

	/// Stroe user data to server.
	/// - throws: network errors
	func patch() async throws -> String {
		if
			gender == prevGender,
			firstname == prevFirstname,
			lastname == prevLastname,
			email == prevEmail,
			phonennumber == prevPhonenumber,
			company == prevCompany {
			throw AppError.customError("status_nochanges")
		}

		return try await AppManager.shared.updateUser(
			email: isEmailChanged ? email : nil,
			password: isEmailChanged ? password : nil,
			gender: Gender(gender).rawValue,
			firstname: firstname,
			lastname: lastname,
			phonennumber: phonennumber.isEmpty ? nil : phonennumber,
			company: company.isEmpty ? nil : company)
	}
}
