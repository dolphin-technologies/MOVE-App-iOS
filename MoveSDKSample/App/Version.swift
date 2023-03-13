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

struct Version {
	/// Version number in the style "<version> (<build>)".
	static var versionString: String {
		guard
			let dictionary = Bundle.main.infoDictionary,
			let versionString = dictionary["CFBundleShortVersionString"] as? String,
			  let build = dictionary["CFBundleVersion"] as? String
		else {
			return ""
		}

		return "\(versionString) (\(build))"
	}
}
