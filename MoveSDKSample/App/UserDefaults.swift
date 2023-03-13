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

/// Helper for retrieving/storing codable objects
extension UserDefaults {
	func encode<T>(_ obj: T?, forKey key: String) where T: Encodable {
		guard let obj = obj else {
			removeObject(forKey: key)
			return
		}

		if let encoded = try? JSONEncoder().encode(obj) {
			set(encoded, forKey: key)
		}
	}

	func decode<T>(forKey key: String) -> T? where T: Decodable {
		if let data: Data = UserDefaults.standard.object(forKey: key) as? Data {
			return try? JSONDecoder().decode(T.self, from: data)
		}

		return nil
	}
}
