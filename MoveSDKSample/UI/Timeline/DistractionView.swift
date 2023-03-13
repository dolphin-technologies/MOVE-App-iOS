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

struct DistractionView: View {
	var details: TripDetails

	let iconHeight: CGFloat = 16.0
	let barHeight: CGFloat = 20.0

	var min = NSLocalizedString("txt_min", comment: "")
	var freeText = NSLocalizedString("txt_free", comment: "")

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10.0)
				.fill(Color.background2)

			HStack(spacing: 16.0) {
				VStack(alignment: .leading, spacing: 0.0) {
					GeometryReader { geometry in
						ZStack(alignment: .leading) {
							ZStack(alignment: .leading) {
								Rectangle()
									.fill(LinearGradient(colors: [Color.buttonPrimary, Color.buttonSecondary], startPoint: .leading, endPoint: .trailing))
									.frame(height: 20.0)
								ForEach(details.segments) { segment in
									switch segment.type {
									case .phone:
										Rectangle()
											.fill(Color.fieldError)
											.frame(width: (segment.endOffset - segment.startOffset) * geometry.size.width, height: barHeight)
											.offset(x: segment.startOffset * geometry.size.width, y: 0)
									case .swipeAndType:
										Rectangle()
											.fill(Color.fieldError)
											.frame(width: (segment.endOffset - segment.startOffset) * geometry.size.width, height: barHeight)
											.offset(x: segment.startOffset * geometry.size.width, y: 0)

									default:
										EmptyView()
									}
								}
								ZStack {
									Circle()
										.stroke(Color.background, lineWidth: 1.5)
									Image("StartBig")
								}
								.offset(CGSize(width: 0, height: 0))
								.frame(width: 20.0, height: 20.0)
								.zIndex(1)
								ZStack {
									Circle()
										.stroke(Color.background, lineWidth: 1.5)
									Image("FinishBig")
								}
								.offset(CGSize(width: geometry.size.width - 20.0, height: 0.0))
								.zIndex(1)
								.frame(width: 20.0, height: 20.0)
							}
							.clipShape(RoundedRectangle(cornerRadius: 10.0))
							ForEach(details.segments) { segment in
								switch segment.type {
								case .phone:
									Image("Phone")
										.frame(height: iconHeight)
										.zIndex(2)
										.offset(CGSize(width: geometry.size.width *  (segment.startOffset + segment.endOffset) * 0.5 - 10.0, height: -16))
								case .swipeAndType:
									Image("SwipeAndType")
										.frame(height: iconHeight)
										.zIndex(2)
										.offset(CGSize(width: geometry.size.width *  (segment.startOffset + segment.endOffset) * 0.5 - 10.0, height: -16))
								default:
									EmptyView()
								}
							}
						}
					}
					.frame(height: 20.0)
					.padding(EdgeInsets(top: 10.0, leading: 0.0, bottom: 10.0, trailing: 0.0))
					HStack {
						Text("\(details.distractedMinutes) \(min)")
							.font(.labelSmall)
						Text("txt_distraction")
						Text("•")
						Text("\(details.distactionFreeMinutes) \(min)")
							.font(.labelSmall)
						Text("txt_distraction")
						Text("txt_free")
					}
				}
				Rectangle()
					.fill(Color.background)
					.frame(width: 1.0)

				ScoreView(score: details.distractionScore, lineWidth: 2)
					.frame(width: 40, height: 40)
					.font(.textBig)
			}
			.font(.textSmall)
			.padding(EdgeInsets(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 16.0))
		}
		.padding(16.0)
		.fixedSize(horizontal: false, vertical: false)
		.frame(maxHeight: .infinity)
    }
}

struct DistractionView_Previews: PreviewProvider {
	static var previews: some View {
		DistractionView(details: TripDetails())
			.frame(height: 144)
	}
}

