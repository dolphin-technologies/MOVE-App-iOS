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
import FirebaseRemoteConfig

class RemoteConfiguration {
	static let shared = RemoteConfiguration()
	let remoteConfig = RemoteConfig.remoteConfig()

	/// Setup firebase remote configuration.
	static func setup() {
		let settings = RemoteConfigSettings()
		settings.minimumFetchInterval = 0
		shared.remoteConfig.configSettings = settings
		/* Load defaults plist file */
		shared.remoteConfig.setDefaults(fromPlist: "RemoteConfig")
		shared.fetch()
	}

	private func fetch() {
		remoteConfig.fetch { (status, error) -> Void in
			if status == .success {
				print("Config fetched!")
				self.remoteConfig.activate { changed, error in
					print("changed config: \(changed)")
				}
			} else {
				print("Config not fetched")
				print("Error: \(error?.localizedDescription ?? "No error available.")")
			}
		}
	}

	/// Get configuration value.
	/// - parameters:
	///   - key: Configuration key
	/// - returns: value as String, optional
	subscript(_ key: String) -> String? {
		let value = remoteConfig.configValue(forKey: key)
		return value.stringValue
	}
}
