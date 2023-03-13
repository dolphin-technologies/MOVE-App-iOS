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

struct RadioButton: View {
	@Binding var value: Int
	let tag: Int
	let label: String

	var body: some View {
		HStack {
			Button {
				value = tag
			} label: {
				ZStack {
					Circle()
						.fill(Color.background)
					Circle()
						.stroke(Color.moveSecondary, lineWidth: 1)
					if value == tag {
						Circle()
							.fill(Color.buttonLink)
							.frame(width: 12.0, height: 12.0)
					}
				}
			}
			.frame(width: 20.0, height: 20.0)
			Text(NSLocalizedString(label, comment: ""))
				.font(.textMedium)
				.foregroundColor(.moveSecondary)
		}
	}
}

struct GenderPicker: View {
	@Binding var value: Int
	let label: String

	var body: some View {
		VStack(alignment: .leading) {
			Text(NSLocalizedString(label, comment: "") + " *")
			HStack(spacing: 20.0) {
				RadioButton(value: $value, tag: 0, label: "lbl_mrs")
				RadioButton(value: $value, tag: 1, label: "lbl_mr")
				RadioButton(value: $value, tag: 2, label: "lbl_nonbinary")
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct GenderPicker_Previews: PreviewProvider {
	static var previews: some View {
		GenderPicker(value: .constant(0), label: "txt_ident")
	}
}
