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

struct TotalScoreView: View {
	var score: Int
	var text: String

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10.0)
				.fill(Color.background2)
			VStack(alignment: .center) {
				ScoreView(score: score, lineWidth: 2)
					.frame(width: 40, height: 40)
					.font(.textBig)
				Text(NSLocalizedString(text, comment: ""))
					.font(.textMedium)
				Text("txt_score")
					.font(.textTiny)
					.foregroundColor(Color.moveSecondary)
			}
		}
		.frame(minWidth: 0, maxWidth: .infinity)
	}
}

struct OverviewView: View {
	var details: TripDetails

	var body: some View {
		HStack(spacing: 16.0) {
			TotalScoreView(score: details.trip.totalScore, text: "txt_total")
			TotalScoreView(score: details.distractionScore, text: "txt_distraction")
			TotalScoreView(score: details.ecoScore, text: "txt_eco_score")
			TotalScoreView(score: details.speedScore, text: "txt-speed_score")
		}
		.fixedSize(horizontal: false, vertical: false)
		.padding(16.0)
		.font(.textSmall)
	}
}

struct OverviewView_Previews: PreviewProvider {
	static var previews: some View {
		OverviewView(details: TripDetails())
			.frame(height: 144)
	}
}
