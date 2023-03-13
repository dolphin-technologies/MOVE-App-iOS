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

struct MessageDetailView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@EnvironmentObject var messageCenter: MessageCenterModel
	@State var message: Message

	let ordinalFormatter = NumberFormatter()
	let dateformatter = DateFormatter()

	init(message: Message) {
		_message = State(wrappedValue: message)
		ordinalFormatter.numberStyle = .ordinal
		dateformatter.dateFormat = "MMMM '%@' yyyy, HH:mm"
	}

    var body: some View {
		VStack(alignment: .leading) {
			HStack {
				VStack(alignment: .leading, spacing: 14.0) {
					Text(format(date: message.timestamp))
						.font(.textMedium)
						.foregroundColor(.moveSecondary)
					Text(message.text)
						.font(.labelBig)
						.foregroundColor(.movePrimary)
				}
				.padding(EdgeInsets(top: 15.0, leading: 16.0, bottom: 15.0, trailing: 16.0))
				Spacer()
			}
			.frame(maxWidth: .infinity)
			.background(Color.background2)

			if let url = message.url {
				WebView(url: url)
			}

			HStack(spacing: 20.0) {
				Button {
					if let prev = message.prev {
						withAnimation {
							message = prev
						}
					}

				} label: {
					Image(systemName: "chevron.left")
				}
				.disabled(message.prev == nil)
				.foregroundColor(message.prev == nil ? .fieldBorder : .movePrimary)

				Button {
					if let next = message.next {
						withAnimation {
							message = next
						}
					}
				} label: {
					Image(systemName: "chevron.right")
				}
				.disabled(message.next == nil)
				.foregroundColor(message.next == nil ? .fieldBorder : .movePrimary)

				Spacer()

				Button {
					if let next = message.next ?? message.prev {
						message = next
					} else {
						self.presentationMode.wrappedValue.dismiss()
					}
					messageCenter.delete(message: message)
				} label: {
					Image("TrashOutline").tint(.movePrimary)
				}
			}
			.foregroundColor(.movePrimary)
			.padding(20.0)
		}
		.onAppear() {
			messageCenter.markAsRead(message: message)
		}
		.onChange(of: message) { newValue in
			messageCenter.markAsRead(message: newValue)
		}
		.navigationBarTitle("tit_messages", displayMode: .inline)
		.navigationBarBackButtonHidden()
		.toolbar {
			NavigationToolbar {
				self.presentationMode.wrappedValue.dismiss()
			}
			ToolbarItem(placement: .primaryAction) {
				Image("MessageFull")
			}
		}
		.accentColor(.title)
	}

	func format(date: Date) -> String {
		let day = NSCalendar.current.component(.day, from: date)
		let dayOrdinal = ordinalFormatter.string(from: day as NSNumber) ?? "\(day)."
		return String(format: dateformatter.string(from: date), dayOrdinal)
	}
}

struct MessageDetailView_Previews: PreviewProvider {
	static var previews: some View {
		MessageDetailView(message: Message(id: -1, read: false, url: URL(string: "https://dolph.in"), text: "Message Text", preview: "Preview", timestamp: Date(), deleted: false))
		.environmentObject(MessageCenterModel())
	}
}
