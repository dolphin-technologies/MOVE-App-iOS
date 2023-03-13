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

class MessageCenterModel: ObservableObject {
	/// The shared message center model.
	/// Needs to accessible by the AppDelegate's received push method.
	/// There maybe a cleaner way to handle this.
	static var shared: MessageCenterModel?

	/// Messages modal sheet presented
	@Published var showingMessages: Bool = false

	/// Unread messages count
	@Published var unreadMessagesBadgeCount: Int = 1

	/// The filtered messages
	@Published var messages: [Message] = []

	private var storedMessages: [Message] = []

	/// Initialize and load persisted messages.
	init() {
		storedMessages = UserDefaults.standard.decode(forKey: "messages") ?? []
		countMessages()
		updateMessages()
		MessageCenterModel.shared = self
	}

	// MARK: API

	/// Fetch messages.
	/// - returns: Whether new messages were fetched. App Delegate's did receive push needs this information.
	/// - throws: network errors
	@discardableResult
	func fetch() async throws -> Bool {
		let messages = try await AppManager.shared.requestMessages()
		DispatchQueue.main.async {
			self.receive(messages: messages)
		}
		return !messages.isEmpty
	}

	/// Mark message as deleted.
	/// The message will be persisted but filtered out.
	/// - parameters:
	///   - message: Message to delete.
	func delete(message: Message) {
		if let prev = message.prev {
			prev.next = message.next
		}

		if let next = message.next {
			next.prev = message.prev
		}

		messages.removeAll { $0.id == message.id }
		if let msg = storedMessages.first(where: { $0.id == message.id} ) {
			msg.deleted = true
			synchronize(messages: [msg])
		}
		UserDefaults.standard.encode(storedMessages, forKey: "messages")
	}

	/// Mark message as read.
	/// - parameters:
	///   - message: Message to be marked.
	func markAsRead(message: Message) {
		/* filter out preview canvas message */
		guard storedMessages.contains(where: { $0.id == message.id }) else { return }
		if !message.read {
			message.read = true
			UserDefaults.standard.encode(storedMessages, forKey: "messages")
			synchronize(messages: [message])
		}
	}

	/// Logout.
	/// Needs to be invoked on (automatic/) logout of the user.
	func logout() {
		unreadMessagesBadgeCount = 0
		messages = []
		storedMessages = []
		UserDefaults.standard.removeObject(forKey: "messages")
	}

	// MARK: Helpers

	private func updateMessages() {
		messages = storedMessages.filter { !$0.deleted }.sorted { $0.timestamp > $1.timestamp }
		var prev: Message?
		for message in messages {
			message.prev = prev
			prev?.next = message
			prev = message
		}
	}

	private func synchronize(messages: [Message]) {
		Task {
			do {
				try	await AppManager.shared.synchronizeMessages(messages)
			} catch {
				print("\(error)")
			}
		}
	}

	private func receive(messages: [ApiMessage]) {
		var newMessages: [Message] = []
		var messagesToSynchronize: [Message] = []
		for message in messages {
			if let msg = storedMessages.first(where: { $0.id == message.id } ) {
				if (msg.deleted && !(message.deleted ?? false))
					|| (msg.read && !(message.read ?? false)) {
					messagesToSynchronize.append(msg)
				}
			} else if let id = message.id {
				let msg = Message(id: id, read: message.read ?? false, url: URL(string: message.url ?? ""), text: message.text ?? "", preview: message.preview ?? "", timestamp: message.sentTime ?? .distantPast, deleted: message.deleted ?? false)
				newMessages.append(msg)
			}
		}

		if !newMessages.isEmpty {
			storedMessages += newMessages
			UserDefaults.standard.encode(storedMessages, forKey: "messages")
			updateMessages()
		}

		countMessages()

		if !messagesToSynchronize.isEmpty {
			synchronize(messages: messagesToSynchronize)
		}
	}

	private func countMessages() {
		unreadMessagesBadgeCount = storedMessages.filter { !$0.read && !$0.deleted }.count
	}
}
