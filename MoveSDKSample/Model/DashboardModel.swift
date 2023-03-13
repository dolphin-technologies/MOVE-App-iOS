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

import Foundation
import Combine
import SwiftUI
import DolphinMoveSDK

class DashboardModel: ObservableObject {
	struct Warning: Hashable {
		let service: String
		let reasons: [String]
	}
	
	/// Instance of the SDKStatesMonitor to track SDK states changes
	@ObservedObject var sdkListeners: SDKStatesMonitor = SDKManager.shared.statesMonitor
	
	/// Current activation view title
	@Published var title: String = NSLocalizedString("lbl_not_recording", comment: "")
	
	/// Current sdk state string
	@Published var currentSDKStateLabel: String = "uninitialized"

	/// State background interpolation.
	@Published var stateGradientOffset: CGFloat = 0.0

	/// Current error display state.
	@Published var showAlert: Bool = false

	/// Warnings, unused.
	@Published var warnings: [Warning] = []

	/// Failures.
	@Published var failures: [Warning] = []

	/// SDK is currently detecting a trip.
	@Published var isDriving: Bool = false

	/// Allows UI to toggle activation state
	@Published var activationToggle: Bool = SDKManager.shared.isSDKStarted {
		willSet {
			print("switching \(activationToggle) -> \(newValue)")
			if newValue != activationToggle {
				SDKManager.shared.toggleMoveSDKState()
			}
		}
	}

	private var state: MoveSDKState = .uninitialized
	private var sdkStatesListener: AnyCancellable? = nil
	private var sdkWarningsListener: AnyCancellable? = nil
	private var sdkFailuresListener: AnyCancellable? = nil
	private var sdkTripStateListener: AnyCancellable? = nil
	private var sdkActivationStateInterceptor: AnyCancellable? = nil
	private var errorsInterceptor: AnyCancellable? = nil
	
	init() {
		/* Forwards SDKStatesMonitor changes to UI */
		sdkStatesListener = sdkListeners.objectWillChange.sink { [weak self] (_) in
			guard let self = self else {return}
			DispatchQueue.main.async {
				self.objectWillChange.send()
			}
		}
		
		/* Track SDK state to set UI variables */
		sdkActivationStateInterceptor = sdkListeners.$state.sink { newValue in
			DispatchQueue.main.async {
				self.state = newValue
				self.setSDKTitleFor(state: newValue)
				self.updateRecordingState()
			}
		}

		sdkWarningsListener = sdkListeners.$warnings.sink {
			var warnings: [Warning] = []
			for warning in $0 {
				let service = warning.service.debugDescription
				var reasons: [String] = []
				switch warning.reason {
				case let .missingPermission(permissions):
					reasons = permissions.map { "\($0)" }
				}
				warnings.append(Warning(service: service, reasons: reasons))
			}
			DispatchQueue.main.async {
				self.warnings = warnings
			}
		}

		sdkFailuresListener = sdkListeners.$failures.sink {
			var warnings: [Warning] = []
			for warning in $0 {
				let service = warning.service.debugDescription
				var reasons: [String] = []
				switch warning.reason {
				case let .missingPermission(permissions):
					reasons = permissions.map { "\($0)" }
				case .unauthorized:
					reasons = ["unauthorized"]
				}
				warnings.append(Warning(service: service, reasons: reasons))
			}
			DispatchQueue.main.async {
				self.failures = warnings
				self.updateRecordingState()
			}
		}


		/* Track error to set UI toast alert  */
		errorsInterceptor = sdkListeners.$alertError.sink { newValue in
			DispatchQueue.main.async {
				self.showAlert = !newValue.isEmpty
			}
		}

		sdkTripStateListener = sdkListeners.$tripState.sink { newValue in
			DispatchQueue.main.async {
				switch newValue {
				case .driving, .halt:
					self.isDriving = true
				default:
					self.isDriving = false
				}
			}
		}
	}

	private func updateRecordingState() {
		if self.failures.isEmpty, state == .running {
			title = NSLocalizedString("lbl_rec", comment: "")
			stateGradientOffset = 1.0
		} else {
			title = NSLocalizedString("lbl_not_recording", comment: "")
			stateGradientOffset = 0.0
		}
	}

	private func setSDKTitleFor(state: MoveSDKState) {
		self.currentSDKStateLabel = "\(state)"
	}
}
