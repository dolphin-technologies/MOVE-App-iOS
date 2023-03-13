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

struct NavigationToolbar: ToolbarContent {
	let dismiss: () -> Void

	var body: some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			Button(action: {
				self.dismiss()
			}) {
				HStack {
					Image(systemName: "chevron.left")
					Text("")
				}
			}
		}
	}
}

func makeNavigationBarGradientImage() -> UIImage {
	let gradient = CAGradientLayer()

	gradient.backgroundColor = .titlebarBackground
	gradient.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 1))
	gradient.colors = CGColor.titlebarGradient
	gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
	gradient.endPoint = CGPoint(x: 1.0, y: 0.0)

	UIGraphicsBeginImageContextWithOptions(gradient.frame.size, true, 0)
	guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
	gradient.render(in: context)
	let outputImage = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	return outputImage ?? UIImage()
}
