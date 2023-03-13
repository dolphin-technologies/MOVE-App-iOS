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

struct ListRowSeperatorModifier: ViewModifier {
	func body(content: Content) -> some View {
		if #available(iOS 15.0, *) {
			content.listRowSeparator(.hidden)
		} else {
			content.onAppear {
				UITableView.appearance().separatorStyle = .none
			}
			.onDisappear {
				UITableView.appearance().separatorStyle = .singleLine
			}
		}
	}
}


extension View {
	func hideListRowSeparator() -> some View  {
		return  self.modifier(ListRowSeperatorModifier())
	}
}

struct MessagesView: View {
	@EnvironmentObject var messageCenter: MessageCenterModel

	let dateFormatter = DateFormatter()

	init() {
		dateFormatter.dateFormat = "dd MMM."
	}

	var body: some View {
		NavigationView {
			VStack {
				if messageCenter.messages.isEmpty {
					VStack(alignment: .center, spacing: 5.0) {
						Text("tit_no_messages_available_yet")
							.multilineTextAlignment(.center)
							.font(.label)
							.foregroundColor(.movePrimary)
						Text("txt_as_soon_as_messages_received")
							.multilineTextAlignment(.center)
							.font(.textMedium)
							.foregroundColor(.moveSecondary)
					}
					.padding(40.0)
					.frame(maxHeight: .infinity)
				} else {
					List {
						ForEach(messageCenter.messages, id: \.id) { message in
							ZStack(alignment: .top) {
								RoundedRectangle(cornerRadius: 10)
									.fill(Color.background2)
								NavigationLink {
									MessageDetailView(message: message)
								} label: { EmptyView() }.opacity(0.0)
								VStack(alignment: .leading) {
									HStack {
										if message.read {
											VStack {}
												.frame(width: 10.0)
										} else {
											Circle()
												.fill(Color.buttonLink)
												.frame(width: 10.0, height: 10.0)
										}
										Text(message.text)
											.foregroundColor(.movePrimary)
											.font(.button)
										Spacer()
										Text(format(date: message.timestamp))
											.foregroundColor(.movePrimary)
											.font(.textSmall)
										Image("ChevronForward")
									}
									HStack {
										VStack {}
											.frame(width: 10.0)
										Text(message.preview)
											.foregroundColor(.moveSecondary)
											.font(.textMedium)
											.lineLimit(2)
											.padding(.trailing, 10.0)
									}
								}
								.padding(EdgeInsets(top: 16.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
							}
							.padding(EdgeInsets(top: 8.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
							.swipeActions {
								Button {
									withAnimation {
										messageCenter.delete(message: message)
									}
								} label: {
									Image("TrashOutline")
										.tint(.title)
								}
								.tint(.badge)
							}
						}
						.listRowSeparator(.hidden)
					}
				}
			}
			.listStyle(.plain)
			.navigationBarTitle("tit_messages", displayMode: .inline)
			.toolbar {
				NavigationToolbar {
					messageCenter.showingMessages = false
				}
				ToolbarItem(placement: .primaryAction) {
					Image("MessageFull")
				}
			}
			.accentColor(.title)
		}
	}

	func format(date: Date) -> String {
		return dateFormatter.string(from: date)
	}
}

struct MessagesView_Previews: PreviewProvider {
	static var previews: some View {
		MessagesView()
			.environmentObject(MessageCenterModel())
	}
}
