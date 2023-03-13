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
import Combine
import SwiftUI

class TimelineModel: ObservableObject {
	static let shared = TimelineModel()

	/// Filter of trips by type.
	enum Filter: Equatable {
		case all
		case car
		case cycling
		case walking
		case idle
		case publicTransport
	}

	private var calendar = Calendar(identifier: .iso8601)

	let parseformatter = DateFormatter()
	let timeFormatter = DateFormatter()

	/// Selected date.
	@Published var date: Date { didSet { fetchTimeline() } }

	/// Duration of car trips for selected date.
	@Published var durationCar: Int = 0

	/// Duration of cycling trips for selected date.
	@Published var durationCycling: Int = 0

	/// Duration of walking trips for selected date.
	@Published var durationWalking: Int = 0

	/// Duration of idle for selected date.
	@Published var durationIdle: Int = 0

	/// Duration of public transport trips for selected date.
	@Published var durationPublicTransport: Int = 0

	/// Filtered trips according to type.
	@Published var filteredTrips: [TimelineEventModel] = []

	/// Current selected filter.
	@Published var filter = Filter.all

	/// Is loading indicator.
	@Published var isLoading = false

	/// All trips for the selected date.
	private var trips: [TimelineEventModel] = []

	// MARK: Public API

	/// Initialize with current date. No data is persisted.
	private init() {
		calendar.timeZone = TimeZone(identifier: "UTC")!
		parseformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		timeFormatter.dateFormat = "HH:mm"

		date = calendar.startOfDay(for: Date())
		fetchTimeline()
	}

	/// Used to disable forward method.
	/// - returns: If selected date is current day.
	var isOnLastDay: Bool {
		calendar.startOfDay(for: Date()) <= date
	}

	/// Next day.
	func nextDay() {
		date = calendar.date(byAdding: DateComponents(day: 1), to: date)!
	}

	/// Previous day.
	func prevDay() {
		date = calendar.date(byAdding: DateComponents(day: -1), to: date)!
	}

	/// Update current filter or filter new date.
	func filterTrips() {
		let trips: [TimelineEventModel] = self.trips.filter {
			switch $0.type {
				case .train, .metro, .bus, .tram, .publicTransport:
				return filter == .all || filter == .publicTransport
				case .walking:
				return filter == .all || filter == .walking
				case .unknown, .idle, .faketrip:
				return filter == .all || filter == .idle
				case .car:
				return filter == .all || filter == .car
				case .cycling:
				return filter == .all || filter == .cycling
			}
		}

		var prev: TimelineEventModel? = nil
		for trip in trips where trip.hasDetails {
			/* zip up trips */
			prev?.next = trip
			trip.prev = prev
			prev = trip
		}

		trips.last?.next = nil

		for trip in trips {
			trip.hasPrev = trip != trips.first
			trip.hasNext = trip != trips.last
		}

		filteredTrips = trips
	}

	// MARK: Helpers

	private func resetDurations() {
		var durationCar = 0
		var durationCycling = 0
		var durationWalking = 0
		var durationIdle = 0
		var durationPublicTransport = 0

		for trip in trips {
			switch trip.type {
			case .train, .metro, .bus, .tram, .publicTransport:
				durationPublicTransport += trip.duration
			case .walking:
				durationWalking += trip.duration
			case .unknown, .idle, .faketrip:
				durationIdle += trip.duration
			case .car:
				durationCar += trip.duration
			case .cycling:
				durationCycling += trip.duration
			}
		}

		self.durationCar = durationCar
		self.durationCycling = durationCycling
		self.durationWalking = durationWalking
		self.durationIdle = durationIdle
		self.durationPublicTransport = durationPublicTransport
	}

	private func fetchTimeline(fallback: Bool = true) {
		isLoading = true
		let date = self.date
		let start = calendar.startOfDay(for: date)
		let end = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: start) ?? Date()

		Task {
			do {
				let timeline = try await AppManager.shared.getTimeline(from: start, to: end)
				DispatchQueue.main.async {
					self.isLoading = false
					if date == self.date {
						let trips = timeline.map {
							TimelineEventModel($0)
						}

						self.trips = trips.sorted(by: { $0.start.timestamp > $1.start.timestamp })
						self.filterTrips()
						self.resetDurations()
					}
				}
			} catch {
				DispatchQueue.main.async {
					self.isLoading = false
					AppManager.shared.errorMessage = "\(error)"
				}
			}
		}
	}
}
