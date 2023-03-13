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

struct ActivationView: View {
	@StateObject var viewModel: DashboardModel

	let shutdownGradient = Gradient(colors: [.stateShutdownBGColor1, .stateShutdownBGColor2])
	let runningGradient = Gradient(colors: [.stateRunningBGColor1, .stateRunningBGColor2])

    var body: some View {
		VStack {
			ZStack(alignment: .top) {
				Rectangle()
					.animatableGradient(fromGradient: shutdownGradient, toGradient: runningGradient, progress: viewModel.stateGradientOffset)
					.animation(.easeInOut(duration: 0.5), value: viewModel.stateGradientOffset)
				Rectangle()
					.fill(Color.background)
					.frame(height: 1.0)
				VStack(alignment: .leading, spacing: 16.0) {
					Text("subtit_current_state")
						.font(.moveHeadlineBig)
						.foregroundColor(.title)
					HStack(alignment: .center) {
						Text(NSLocalizedString(viewModel.title, comment: ""))
							.font(.button)
						Toggle("", isOn: $viewModel.activationToggle)
					}
					.padding(15.0)
					.background(Color.background2)
					.cornerRadius(10.0)
				}
				.padding(16.0)
			}
			.fixedSize(horizontal: false, vertical: true)
		}
	}
}

struct ActivationView_Previews: PreviewProvider {
    static var previews: some View {
		ActivationView(viewModel: DashboardModel())
    }
}
