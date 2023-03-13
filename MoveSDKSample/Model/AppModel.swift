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

import Combine
import SwiftUI

import AlertToast

class AppModel: ObservableObject {
	struct Alert {
		let message: String
		let type: AlertToast.AlertType
		static func error(message: String) -> Alert {
			Alert(message: message, type: .error(.red))
		}
		static func complete(message: String) -> Alert {
			Alert(message: message, type: .complete(.green))
		}
	}

	var appManager = AppManager.shared

	private var loginListener: AnyCancellable? = nil
	private var errorListener: AnyCancellable? = nil

	/// User identifier string.
	@Published var userID: String?

	/// Whether to show general loading indicator.
	@Published var isLoading: Bool = false

	/// Whether to present general alert.
	@Published var isPresentingAlert: Bool = false

	/// General alert.
	@Published var alert: Alert = .error(message: "") {
		didSet {
			if !alert.message.isEmpty {
				isPresentingAlert = true
			}
		}
	}

	init() {
		loginListener = appManager.$userID.sink { newValue in
			self.userID = newValue
		}

		errorListener = appManager.$errorMessage.sink { newValue in
			if let message = newValue {
				self.alert = .error(message: message)
			}
		}
	}
}
