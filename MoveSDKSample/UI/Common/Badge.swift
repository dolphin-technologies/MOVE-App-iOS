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

struct Badge: View {
	@Binding var count: Int

	var body: some View {
		if count > 0 {
			ZStack(alignment: .topTrailing) {
				Color.clear
				Text(String(count))
					.foregroundColor(.title)
					.font(.system(size: 16))
					.padding(5)
					.background(Color.badge)
					.clipShape(Circle())
				/* custom positioning in the top-right corner */
					.alignmentGuide(.top) { $0[.bottom] }
					.alignmentGuide(.trailing) { $0[.trailing] - $0.width * 0.15 }
			}
		}
	}
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
		Badge(count: .constant(3))
    }
}
