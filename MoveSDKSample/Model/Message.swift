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

class Message: Identifiable, Codable, Equatable {
	private enum CodingKeys: String, CodingKey {
		case id
		case read
		case url
		case text
		case preview
		case timestamp
		case deleted
	}

	static func == (lhs: Message, rhs: Message) -> Bool {
		lhs.id == rhs.id
	}

	var id: Int
	var read: Bool
	var url: URL?
	var text: String
	var preview: String
	var timestamp: Date
	var deleted: Bool

	weak var prev: Message?
	weak var next: Message?

	init(id: Int, read: Bool, url: URL?, text: String, preview: String, timestamp: Date, deleted: Bool) {
		self.id = id
		self.read = read
		self.url = url
		self.text = text
		self.preview = preview
		self.timestamp = timestamp
		self.deleted = deleted
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(id, forKey: .id)
		try container.encode(read, forKey: .read)
		try container.encodeIfPresent(url, forKey: .url)
		try container.encode(text, forKey: .text)
		try container.encode(preview, forKey: .preview)
		try container.encode(timestamp, forKey: .timestamp)
		try container.encode(deleted, forKey: .deleted)
	}
}
