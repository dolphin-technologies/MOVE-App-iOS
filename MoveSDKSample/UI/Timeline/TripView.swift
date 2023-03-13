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

struct TripView: View {
	@Binding var trip: TimelineEventModel

	var body: some View {
		NavigationLink {
			TripDetailView(trip: trip)
		} label: {
			VStack(alignment: .leading, spacing: 0) {
				HStack {
					Image(image(from: trip.type))
						.foregroundColor(.black)
						.frame(width: 20.0)

					ZStack(alignment: .center) {
						VStack {
							Rectangle()
								.fill(trip.hasPrev ? Color.black : Color.clear)
								.frame(width: 1.0)
								.frame(maxHeight: .infinity)
							Rectangle()
								.fill(trip.hasNext ? Color.black : Color.clear)
								.frame(width: 1.0)
								.frame(maxHeight: .infinity)
						}
						Circle()
							.fill(Color.background2)
							.frame(width: 9, height: 9)
						Circle()
							.stroke(Color.black, lineWidth: 1)
							.frame(width: 9, height: 9)
					}
					.frame(width: 20, height: 60)
					Text(string(from: trip.type))
						.font(.moveHeadline)
				}
				.fixedSize(horizontal: false, vertical: true)
				HStack(alignment: .top) {
					if trip.hasDetails {
						ScoreView(score: trip.totalScore, lineWidth: 2)
							.frame(width: 20, height: 20)
							.foregroundColor(.movePrimary)
							.font(.labelTiny)
					} else {
						Rectangle()
							.fill(Color.clear)
							.frame(width: 20, height: 20)
					}
					ZStack(alignment: .center) {
						Rectangle()
							.fill(trip.hasNext ? Color.black : Color.clear)
							.frame(width: 1.0)
							.frame(maxHeight: .infinity)
					}
					.frame(width: 20)
					VStack(alignment: .leading, spacing: 5.0) {
						Text(trip.dates).padding(EdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 0))
						if trip.hasDetails {
							HStack {
								Text("txt_from")
									.font(.labelSmall)
								Text(trip.start.address)
									.multilineTextAlignment(.leading)
							}
							HStack {
								Text("txt_to_big")
									.font(.labelSmall)
								Text(trip.end.address)
									.multilineTextAlignment(.leading)
							}
						}
						Spacer().frame(height: 10.0)
						if trip.hasNext {
							Rectangle()
								.fill(Color.background)
								.frame(height: 1.0)
						}
					}
					.fixedSize(horizontal: false, vertical: true)
					Spacer()
				}
				.fixedSize(horizontal: false, vertical: true)
				.font(.textSmall)
			}
			.padding(EdgeInsets(top: 0.0, leading: 15.0, bottom: 0.0, trailing: 0.0))
			.foregroundColor(.movePrimary)
		}
		.disabled(!trip.hasDetails)
	}

	func image(from type: ApiTimelineItemType) -> String {
		switch type {
		case .bus, .publicTransport, .train, .tram, .metro:
			return "PublicTransport"
		case .walking:
			return "Walking"
		case .unknown, .faketrip:
			return "Pause"
		case .car:
			return "Driving"
		case .idle:
			return "Idle"
		case .cycling:
			return "Cycling"
		}
	}

	func string(from type: ApiTimelineItemType) -> String {
		switch type {
		case .bus, .publicTransport, .train, .tram, .metro:
			return NSLocalizedString("subtit_public_transport", comment: "")
		case .walking:
			return NSLocalizedString("subtit_walking", comment: "")
		case .unknown, .faketrip:
			return "UNKNOWN"
		case .car:
			return NSLocalizedString("subtit_car", comment: "")
		case .idle:
			return NSLocalizedString("subtit_idle", comment: "")
		case .cycling:
			return NSLocalizedString("subtit_bicycle", comment: "")
		}
	}
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
		TripView(trip: .constant(TimelineEventModel()))
			.background(Color.background2)
    }
}
