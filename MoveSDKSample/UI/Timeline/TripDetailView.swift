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

import AlertToast
import SwiftUI
import MapKit

struct TabButton: View {
	@Binding var value: Int
	var tag: Int
	var label: String

	var body: some View {
		Button {
			withAnimation(.easeInOut(duration: 0.2)) {
				value = tag
			}
		} label: {
			Text(NSLocalizedString(label, comment: ""))
				.foregroundColor(value == tag ? Color.buttonLink : Color.movePrimary)
				.frame(maxWidth: .infinity)
		}
	}
}

struct TripDetailView: View {
	@EnvironmentObject var appModel: AppModel
	@EnvironmentObject var messageCenter: MessageCenterModel
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@State var trip: TimelineEventModel

	@State var details: TripDetails?
	@State var scoreIndex: Int = 0
	@State var loadingDetails = false
	@State var showError = false
	@State var loadingError = ""

	@State private var region = TripDetailView.makeRegion(coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275))

	var body: some View {
		VStack(spacing: 0.0) {
			ZStack {
				Color.background2
					.frame(height: 73)
				HStack(spacing: 16.0) {
					TimelineDateView(date: $trip.start.timestamp)

					VStack(alignment: .leading) {
						Text(trip.dates).padding(EdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 0))
						if trip.hasDetails {
							HStack {
								Text("txt_from")
								Text(trip.start.address)
									.font(.textSmall)
							}
							HStack {
								Text("txt_to_big")
								Text(trip.end.address)
									.font(.textSmall)
							}
						}
						Spacer()
							.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 0)
					}
					.font(.labelSmall)
					ScoreView(score: trip.totalScore, lineWidth: 2)
						.font(.textBig)
						.frame(width: 39, height: 39)
						.foregroundColor(.movePrimary)
				}
				.padding(EdgeInsets(top: 8.0, leading: 16.0, bottom: 8.0, trailing: 16.0))
			}
			.frame(height: 73)

			HStack(alignment: .center) {
				Button {
					if let prev = trip.prev { trip = prev }
				} label: {
					Image(systemName: "chevron.left")
					Text("txt_previous_trip")
				}
				.disabled(trip.prev == nil)
				.foregroundColor(trip.prev == nil ? .buttonDisabled : .buttonLink)
				Spacer()
				Button {
					if let next = trip.next { trip = next }
				} label: {
					Text("txt_next_trip")
					Image(systemName: "chevron.right")
				}
				.disabled(trip.next == nil)
				.foregroundColor(trip.next == nil ? .buttonDisabled : .buttonLink)
			}
			.font(.button)
			.padding(16.0)
			ZStack(alignment: .bottom) {
				MapView(mode: $scoreIndex, details: $details)
					.fixedSize(horizontal: false, vertical: false)
				Rectangle()
					.frame(height: 10)
					.foregroundColor(.background)
					.padding(.bottom, 10.0)
					.cornerRadius(10.0)
					.padding(.bottom, -10.0)
					.shadow(color: Color.black.opacity(0.15), radius: 8.0, x: 0.0, y: -2)
			}

			if let details = details {

				GeometryReader { geometry in
					ZStack(alignment: .bottomLeading) {
						HStack(alignment: .top) {
							TabButton(value: $scoreIndex, tag: 0, label: "btn_overview")
							TabButton(value: $scoreIndex, tag: 1, label: "btn_distraction")
							TabButton(value: $scoreIndex, tag: 2, label: "btn_safeness")
							TabButton(value: $scoreIndex, tag: 3, label: "btn_speed")
						}
						.offset(CGSize(width: 0.0, height: -7))
						.frame(height: 42.0)
						Rectangle()
							.fill(Color.fieldBorder)
							.frame(height: 2.0)
						Rectangle()
							.fill(Color.buttonLink)
							.frame(width: geometry.size.width / 4.0, height: 2)
							.offset(CGSize(width: geometry.size.width / 4.0 * CGFloat(scoreIndex), height: 0.0))
					}
					.background(Color.background)
					.font(.button)
				}
				.frame(height: 33.0)

				VStack(spacing: 0.0) {
					switch scoreIndex {
					case 0:
						OverviewView(details: details)
					case 1:
						DistractionView(details: details)
					case 2:
						EcoView(details: details)
					case 3:
						SpeedView(details: details)
					default:
						Text("")
					}
				}
				.frame(height: 144)
			}
		}
		.frame(minHeight: 0, maxHeight: .infinity)
		.navigationBarTitle("tit_trip_details", displayMode: .inline)
		.navigationBarBackButtonHidden()
		.toolbar {
			NavigationToolbar {
				self.presentationMode.wrappedValue.dismiss()
			}
			MessageToolbar(messageCenter: messageCenter)
		}
		.accentColor(.title)
		.onAppear() {
			reload()
		}
		.onChange(of: trip) { _ in
			reload()
		}
		.toast(isPresenting: $loadingDetails) {
			AlertToast(type: .loading)
		}
		.toast(isPresenting: $showError) {
			AlertToast(type: .error(.red), title: loadingError)
		}
	}

	func reload() {
		loadingDetails = true
		details = nil
		Task {
			do {
				let details = try await trip.fetchDetails()
				DispatchQueue.main.async {
					self.loadingDetails = false
					self.details = details
				}
			} catch AppError.logout {
				DispatchQueue.main.async {
					self.loadingDetails = false
					appModel.alert = .error(message: "\(AppError.logout)")
				}
			} catch {
				DispatchQueue.main.async {
					self.loadingDetails = false
					self.loadingError = "\(error)"
				}
			}
		}
	}

	static func makeRegion(coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
		MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
	}
}

struct TripDetailView_Previews: PreviewProvider {
    static var previews: some View {
		TripDetailView(trip: TimelineEventModel(), details: TripDetails())
			.environmentObject(AppModel())
    }
}
