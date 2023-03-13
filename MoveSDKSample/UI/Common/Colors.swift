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

import simd
import SwiftUI

extension Color {
	static let background = Color("background")
	static let background2 = Color("background2")
	static let badge = Color("badge")
	static let warning = Color("warning")

	static let fieldError = Color("error")
	static let fieldBorder = Color("border")

	static let scoreHigh = Color("scoreHigh")
	static let scoreMedium = Color("scoreMedium")
	static let scoreLow = Color("scoreLow")

	static let buttonLink = Color("link")
	static let buttonPrimary = Color("buttonPrimary")
	static let buttonSecondary = Color("buttonSecondary")
	static let buttonDisabled = Color("buttonDisabled")

	static let movePrimary = Color("primary")
	static let moveSecondary = Color("secondary")

	static let stateRunningBGColor1 = Color("runningPrimary")
	static let stateRunningBGColor2 = Color("runningSecondary")

	static let stateShutdownBGColor1 = Color("shutdownPrimary")
	static let stateShutdownBGColor2 = Color("shutdownSecondary")

	static let title = Color("title")
}

extension UIColor {
	static let weightHigh = UIColor(named: "weightHigh")!
	static let weightMedium = UIColor(named: "weightMedium")!
	static let weightLow = UIColor(named: "weightLow")!

	static let title = UIColor(named: "title")!
	static let tabBar = UIColor(named: "tabBar")!
}

extension CGColor {
	static let titlebarBackground = UIColor(named: "primary")!.cgColor
	static let titlebarGradient: [CGColor] = [
		UIColor(named: "titlebar0")!,
		UIColor(named: "titlebar1")!,
		UIColor(named: "titlebar2")!
	].map {
		$0.withAlphaComponent(0.35).cgColor
	}
}
