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

import UIKit
import SwiftUI

extension UIFont {
	static let callout = UIFont(name: "Helvetica Neue", size: 12.0)!
	static let title = UIFont(name: "HelveticaNeue-Black", size: 22.0)!
}

extension Font {
	private static let baseName = "Helvetica Neue"
	static let button = Font.custom(baseName, fixedSize: 14.0).weight(.bold)
	static let field = Font.custom(baseName, fixedSize: 16.0)

	static let labelTiny = Font.custom(baseName, fixedSize: 10.0).weight(.bold)
	static let labelSmall = Font.custom(baseName, fixedSize: 12.0).weight(.bold)
	static let label = Font.custom(baseName, fixedSize: 16.0).weight(.bold)
	static let labelBig = Font.custom(baseName, fixedSize: 18.0).weight(.bold)
	static let labelHuge = Font.custom(baseName, fixedSize: 20.0).weight(.bold)

	static let textTiny = Font.custom(baseName, fixedSize: 10.0)
	static let textInfo = Font.custom(baseName, fixedSize: 11.0)
	static let textSmall = Font.custom(baseName, fixedSize: 12.0)
	static let textMedium = Font.custom(baseName, fixedSize: 14.0)
	static let textBig = Font.custom(baseName, fixedSize: 19.8)

	static let moveTitle = Font.custom(baseName, fixedSize: 20.0).weight(.black)
	static let moveHeadline = Font.custom(baseName, fixedSize: 16.0).weight(.black)
	static let moveHeadlineBig = Font.custom(baseName, fixedSize: 17.0).weight(.black)
	static let moveHeadlineSmall = Font.custom(baseName, fixedSize: 14.0).weight(.black)
}
