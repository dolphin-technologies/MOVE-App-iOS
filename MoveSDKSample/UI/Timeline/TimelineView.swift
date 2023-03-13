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
import AlertToast

struct TimelineDateView: View {
	@Binding var date: Date
	let formatter = DateFormatter()

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 8)
				.fill(Color.movePrimary)
			VStack {
				Text(day(date: date))
					.font(.textSmall)
				Text(time(date: date))
					.font(.moveHeadlineSmall)
			}
			.foregroundColor(.title)
		}
		.frame(width: 57, height: 57)
	}

	func day(date: Date) -> String {
		formatter.dateFormat = "E"
		return formatter.string(from: date)
	}

	func time(date: Date) -> String {
		formatter.dateFormat = "dd.MM"
		return formatter.string(from: date)
	}
}

struct TimelineModeView: View {
	struct Style: LabelStyle {
		func makeBody(configuration: Configuration) -> some View {
			VStack {
				configuration.icon
				configuration.title
					.font(.textTiny)
			}
		}
	}

	@Binding var value: TimelineModel.Filter
	@Binding var duration: Int

	let image: String
	let tag: TimelineModel.Filter
	var isOn: Bool {
		value == tag
	}

	var body: some View {
		Button {
			if value == tag {
				value = .all
			} else {
				value = tag
			}
		} label: {
			Label(string(from: duration), image: image)
				.multilineTextAlignment(.center)
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 60.0)

				.foregroundColor(isOn ? .background : .moveSecondary)
				.labelStyle(Style())
		}
		.frame(width: 57, height: 57)
		.background (
			RoundedRectangle(cornerRadius: 8)
				.fill(isOn ? Color.movePrimary : .clear)
		)
	}

	func string(from duration: Int) -> String {
		var label = ""
		let minutes = duration % 60
		let hours = duration / 60
		if hours > 0 {
			label += "\(hours)h "
		}
		label += "\(minutes)m"
		return label
	}
}

struct TimelineView: View {
	@EnvironmentObject var messageCenter: MessageCenterModel
	@StateObject var viewModel: DashboardModel
	@StateObject var timeline = TimelineModel.shared
	@StateObject var statesMonitor = SDKManager.shared.statesMonitor

	@State var mode = -1
	@State var showPicker = false

	var body: some View {
		NavigationView {
			VStack(spacing: 0.0) {
				ZStack {
					Color.background2
						.frame(height: 73)
					HStack(spacing: 0.0) {
						Button {
							withAnimation {
								showPicker.toggle()
							}
						} label: {
							TimelineDateView(date: $timeline.date)
						}
						.frame(maxWidth: .infinity)

						TimelineModeView(value: $timeline.filter, duration: $timeline.durationCar, image: "Driving", tag: .car)
							.frame(maxWidth: .infinity)

						TimelineModeView(value: $timeline.filter, duration: $timeline.durationCycling, image: "Cycling", tag: .cycling)
							.frame(maxWidth: .infinity)

						TimelineModeView(value: $timeline.filter, duration: $timeline.durationPublicTransport, image: "PublicTransport", tag: .publicTransport)
							.frame(maxWidth: .infinity)

						TimelineModeView(value: $timeline.filter, duration: $timeline.durationWalking, image: "Walking", tag: .walking)
							.frame(maxWidth: .infinity)

						TimelineModeView(value: $timeline.filter, duration: $timeline.durationIdle, image: "Idle", tag: .idle)
							.frame(maxWidth: .infinity)

					}
					.padding(8.0)
				}
				.background(Color.red)
				.frame(height: 73)
				if !statesMonitor.failures.isEmpty {
					Text("err_permissions")
						.font(.textMedium)
						.multilineTextAlignment(.center)
						.foregroundColor(.title)
						.padding(10.0)
						.frame(maxWidth: .infinity)
						.background(RoundedRectangle(cornerRadius: 10.0).fill(Color.warning))
						.padding(15.0)
				}
				HStack {
					Button {
						withAnimation {
							timeline.prevDay()
						}
					} label: {
						Image(systemName: "chevron.left")
						Text("txt_previous_day")
					}
					.foregroundColor(.buttonLink)
					Spacer()
					Button {
						withAnimation {
							timeline.nextDay()
						}
					} label: {
						Text("txt_next_day")
						Image(systemName: "chevron.right")
					}
					.disabled(timeline.isOnLastDay)
					.foregroundColor(timeline.isOnLastDay ? .buttonDisabled : .buttonLink)

				}
				.padding(16.0)
				.font(.button)
				if showPicker {
					VStack {
						DatePicker("", selection: $timeline.date, in: ...Date(), displayedComponents: .date)
							.datePickerStyle(.graphical)
							.accentColor(.movePrimary)
						HStack(spacing: 20.0) {
							Button("Today") {
								timeline.date = Date()
							}
							.buttonStyle(MoveBottomButtonStyle())
							Button("Select") {
								withAnimation {
									showPicker.toggle()
								}
							}
							.buttonStyle(MoveButtonStyle())
							.padding(20.0)
						}
					}
				} else if timeline.filteredTrips.isEmpty {
					VStack(alignment: .center, spacing: 5.0) {
						Text("tit_no_data_for_chosen_day")
							.multilineTextAlignment(.center)
							.font(.label)
							.foregroundColor(.movePrimary)
						Text("txt_as_soon_as_we_record")
							.multilineTextAlignment(.center)
							.font(.textMedium)
							.foregroundColor(.moveSecondary)
					}
					.padding(40.0)
					.frame(maxHeight: .infinity)
				} else {
					ScrollView {
						ZStack {
							RoundedRectangle(cornerRadius: 10.0)
								.fill(Color.background2)
							VStack(spacing: 0) {
								ForEach($timeline.filteredTrips) { trip in
									TripView(trip: trip)
								}
							}
						}
						.padding(EdgeInsets(top: 0.0, leading: 20.0, bottom: 10.0, trailing: 20.0))
					}
					.frame(maxWidth: .infinity)
					Spacer()
				}
			}
			.foregroundColor(.black)
			.navigationBarTitle("tit_timeline", displayMode: .inline)
			.toolbar {
				MessageToolbar(messageCenter: messageCenter)
			}
			.accentColor(.title)
			.toast(isPresenting: $timeline.isLoading) {
				AlertToast(displayMode: .alert, type: .loading)
			}
			.onChange(of: timeline.filter) { newValue in
				withAnimation(.easeInOut(duration: 0.2)) {
					timeline.filterTrips()
				}
			}
		}
	}
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
		TimelineView(viewModel: DashboardModel())
		.environmentObject(MessageCenterModel())
    }
}
