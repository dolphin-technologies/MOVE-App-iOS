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

struct SpeedView: View {
	var details: TripDetails

    var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10.0)
				.fill(Color.background2)
			HStack(spacing: 16.0) {
				VStack(alignment: .leading, spacing: 16.0) {
					HStack {
						Text("txt_within_limits")
						Text(string(distance: details.greenKm))
							.font(.textSmall)
					}
					HStack {
						Text("< 10% over")
						Text("txt_limits")
						Text(string(distance: details.yellowKm))
							.font(.textSmall)
					}
					HStack {
						Text("> 10% over")
						Text("txt_limits")
						Text(string(distance: details.redKm))
							.font(.textSmall)

					}
				}
				Spacer()
				Rectangle()
					.fill(Color.background)
					.frame(width: 1.0)
				VStack(alignment: .center) {
					ScoreView(score: details.speedScore, lineWidth: 2)
						.frame(width: 40, height: 40)
						.font(.textBig)
				}
			}
			.padding(EdgeInsets(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 16.0))
		}
		.padding(16.0)
		.fixedSize(horizontal: false, vertical: false)
		.font(.labelSmall)
	}

	func string(distance: Int) -> String {
		let km = (Float(distance) / 100.0).rounded() / 10.0
		return "\(km) km"
	}
}

struct SpeedView_Previews: PreviewProvider {
	static var previews: some View {
		SpeedView(details: TripDetails())
			.frame(height: 144)
	}
}
