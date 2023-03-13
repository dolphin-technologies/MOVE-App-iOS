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

struct ScoreArc: Shape {
	var score: Int
	var size: CGSize
	var lineWidth: Double

	func path(in rect: CGRect) -> Path {
		var p = Path()
		let cap = 360 * score / 100

		p.addArc(center: CGPoint(x: size.width / 2.0, y: size.height / 2.0), radius: size.width / 2.0, startAngle: .degrees(Double(-90 + cap)), endAngle: .degrees(-90), clockwise: true)

		return p.strokedPath(.init(lineWidth: lineWidth, lineCap: .round))
	}
}

struct ScoreView: View {
	var score: Int
	var lineWidth: Double

	var body: some View {
		ZStack {
			Text("\(score)")
			Circle()
				.stroke(Color.movePrimary.opacity(0.4), lineWidth: lineWidth)
			GeometryReader { geometry in
				ScoreArc(score: score, size: geometry.size, lineWidth: lineWidth)
					.foregroundColor(score > 66 ? .scoreHigh : (score > 33 ? .scoreMedium : .scoreLow))
			}
		}
	}
}

struct ScoreView_Previews: PreviewProvider {
	static var previews: some View {
		ScoreView(score: 66, lineWidth: 6)
			.frame(width: 50, height: 50)
			.font(.moveTitle)
	}
}
