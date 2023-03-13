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

struct WebSheet: View {
	let title: String
	let path: String

	var body: some View {
		VStack {
			Text(NSLocalizedString(title, comment: ""))
				.font(.labelBig)
				.padding(EdgeInsets(top: 15, leading: 0, bottom: 10, trailing: 0))
			Divider()
			WebView(config: path)
		}
    }
}