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

/// Error Handling used for API
enum AppError: Error, CustomStringConvertible {
	case customError(String)
	case logout
	case networkError
	case parserError
	case timeout
	case tokenExpired
	case cancelled
	case serverError(String)

	var description: String {
		switch self {
		case .tokenExpired, .cancelled:
			return ""
		case .logout:
			return NSLocalizedString("txt_signed_in_on_another_device", comment: "")
		case let .customError(message):
			return message
		case let .serverError(message):
			return message
		default:
			return NSLocalizedString("err_network_error", comment: "")
		}
	}
}

