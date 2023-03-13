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

struct Checkbox<Content: View>: View {
	@Binding var isChecked: Bool
	@State var isPresenting: Bool = false

	let label: String
	let link: String
	@ViewBuilder var sheet: () -> Content

	init(isChecked: Binding<Bool>, label: String, link: String, @ViewBuilder sheet: @escaping () -> Content ) {
		_isChecked = isChecked
		self.label = label
		self.link = link
		self.sheet = sheet
	}

	var body: some View {
		HStack {
			Toggle(isOn: $isChecked) {
			}
			.toggleStyle(CheckToggleStyle())
			.sheet(isPresented: $isPresenting, content: sheet)
			Button {
				isPresenting = true
			} label: {
				Group {
					Text(NSLocalizedString(label, comment: ""))
						.foregroundColor(Color.moveSecondary)
					+ Text(" ")
					+ Text(NSLocalizedString(link, comment: ""))
						.foregroundColor(Color.buttonLink)
				}
				.multilineTextAlignment(.leading)
			}
			.font(.textMedium)
		}
    }
}
