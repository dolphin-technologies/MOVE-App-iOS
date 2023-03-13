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

struct MoveTextFieldStyle: TextFieldStyle {
	func _body(configuration: TextField<Self._Label>) -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: 5.0)
				.fill(.background)
			RoundedRectangle(cornerRadius: 5.0)
				.stroke(Color.fieldBorder, lineWidth: 1)
			configuration
				.padding(.leading)
				.foregroundColor(.black)
				.font(.field)
				.accentColor(.moveSecondary)
		}
		.frame(height: 48)
	}
}

struct MoveNavigationLingStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		VStack(spacing: 0.0) {
			HStack {
				configuration.label
					.font(.button)
					.padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 16))
					.foregroundColor(configuration.isPressed ? Color.buttonDisabled : Color.movePrimary)
					.frame(maxWidth: .infinity, alignment: .leading)
				Image(systemName: "chevron.right")
					.foregroundColor(configuration.isPressed ? Color.buttonDisabled : Color.moveSecondary)
			}
			.background(Color.background)
			.padding([.trailing], 16.0)
			Divider()
		}
	}
}

struct MoveButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(.button)
			.padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
			.foregroundColor(.title)
			.frame(minWidth: 0, maxWidth: .infinity, minHeight: 36)
			.background(
				RoundedRectangle(cornerRadius: 5)
					.fill(LinearGradient(gradient: Gradient(colors: [Color.buttonPrimary, configuration.isPressed ? Color.buttonPrimary : Color.buttonSecondary]), startPoint: .top, endPoint: .bottom))
			)
	 }
}

struct MoveBottomButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(.textMedium)
			.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
			.foregroundColor(configuration.isPressed ? Color.green.opacity(0.5) : Color.buttonLink)
			.frame(minWidth: 0, maxWidth: .infinity)
	 }
}

struct CheckToggleStyle: ToggleStyle {
	func makeBody(configuration: Configuration) -> some View {
		Button {
			configuration.isOn.toggle()
		} label: {
			Label {
				configuration.label
			} icon: {
				if configuration.isOn {
					ZStack {
						RoundedRectangle(cornerRadius: 5)
							.fill(Color.buttonSecondary)
						Image("CheckmarkIcon")
					}
					.frame(width: 20, height: 20)
				} else {
					ZStack {
						RoundedRectangle(cornerRadius: 5)
							.fill(.background)
						RoundedRectangle(cornerRadius: 5)
							.stroke(Color.fieldBorder, lineWidth: 1)
					}
					.frame(width: 20, height: 20)
				}
			}
		}
		.buttonStyle(PlainButtonStyle())
	}
}

extension CALayer {
	func toImage() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(frame.size, isOpaque, 0)
		guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
		render(in: context)
		let outputImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return outputImage ?? UIImage()
	}
}
