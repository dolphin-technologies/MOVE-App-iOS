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

struct EcoView: View {
	var details: TripDetails

    var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10.0)
				.fill(Color.background2)
			HStack(spacing: 16.0) {
				VStack(alignment: .leading, spacing: 8.0) {
					Text("txt_eco1")
						.font(.labelSmall)
					HStack {
						Text("txt_moderate")
						Text("\(details.accelerationCount.0)")
					}
					HStack {
						Text("txt_strong")
						Text("\(details.accelerationCount.1)")
					}
					HStack {
						Text("txt_extreme")
						Text("\(details.accelerationCount.2)")
					}
				}
				.frame(minWidth: 0, maxWidth: .infinity)
				VStack(alignment: .leading, spacing: 8.0) {
					Text("txt_braking")
						.font(.labelSmall)
					HStack {
						Text("txt_moderate")
						Text("\(details.brakingCount.0)")
					}
					HStack {
						Text("txt_strong")
						Text("\(details.brakingCount.1)")
					}
					HStack {
						Text("txt_extreme")
						Text("\(details.brakingCount.2)")
					}
				}
				.frame(minWidth: 0, maxWidth: .infinity)
				VStack(alignment: .leading, spacing: 8.0) {
					Text("txt_cornering")
						.font(.labelSmall)
					HStack {
						Text("txt_moderate")
						Text("\(details.corneringCount.0)")
					}
					HStack {
						Text("txt_strong")
						Text("\(details.corneringCount.1)")
					}
					HStack {
						Text("txt_extreme")
						Text("\(details.corneringCount.2)")
					}
				}
				.frame(minWidth: 0, maxWidth: .infinity)
				Rectangle()
					.fill(Color.background)
					.frame(width: 1.0)
				VStack {
					ScoreView(score: details.ecoScore, lineWidth: 2)
						.frame(width: 40, height: 40)
						.font(.textBig)
				}
			}
			.padding(EdgeInsets(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 16.0))
		}
		.padding(16.0)
		.fixedSize(horizontal: false, vertical: false)
		.font(.textSmall)
    }
}

struct EcoView_Previews: PreviewProvider {
	static var previews: some View {
		EcoView(details: TripDetails())
			.frame(height: 144)
	}
}
