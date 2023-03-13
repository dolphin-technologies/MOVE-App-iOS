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
import SwiftUI
import DolphinMoveSDK

class SDKStatesMonitor: ObservableObject {

	/// Reflects SDK logs
	@Published var logMessage: String = "-"
	
	/// Reflects SDK state
	@Published var state: MoveSDKState = .uninitialized

	/// Reflects SDK trip state
	@Published var tripState: MoveTripState = .unknown
	
	/// Reflects SDK auth state
	@Published var authState: String = "-"
	
	/// Reflects SDK contract id that SDKManager generates automatically for each app instance.
	@Published var contractID: String = " "
	
	/// Reflect error messages from SDKManager or the SDK itself.
	@Published var alertError: String = ""

	/// Reflects SDK Warnings
	@Published var warnings: [MoveServiceWarning] = []

	/// Reflects SDK Failures
	@Published var failures: [MoveServiceFailure] = []
}
