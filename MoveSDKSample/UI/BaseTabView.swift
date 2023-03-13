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

import AlertToast
import SwiftUI

struct BaseTabView: View {
	@EnvironmentObject var appModel: AppModel
	@Environment(\.scenePhase) var scenePhase

	@StateObject var viewModel: DashboardModel = DashboardModel()
	@StateObject var messageCenter = MessageCenterModel()

	@State var activeTab: Int = 0
	@State var markerOffset: CGFloat = 0

	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .bottomLeading) {
				TabView(selection: $activeTab) {
					Dashboard(viewModel: viewModel)
						.ignoresSafeArea()
						.tabItem {
							Label("tab_status", image: "Status")
						}
						.tag(0)

					TimelineView(viewModel: viewModel)
						.tabItem {
							Label("tab_timeline", image: "Timeline")
						}
						.tag(1)
					MoreView(viewModel: viewModel)
						.tabItem {
							Label("tab_more", image: "More")
						}
						.tag(2)
				}
				.accentColor(.buttonLink)
				.sheet(isPresented: $messageCenter.showingMessages) {
					MessagesView()
				}
				.environmentObject(messageCenter)
				.onChange(of: activeTab) { newValue in
					withAnimation(.easeInOut(duration: 0.2)) {
						markerOffset = geometry.size.width / 3.0 * CGFloat(activeTab)
					}
				}
				.onChange(of: scenePhase) { newPhase in
					if newPhase == .active {
						self.fetchMessages()
					}
				}
				.onAppear() {
					/* prevent redundant call */
					if scenePhase == .active {
						/* called on login */
						fetchMessages()
					}
				}
				.onDisappear() {
					/* called on logout */
					messageCenter.logout()
				}
				.toast(isPresenting: $appModel.isPresentingAlert) {
					AlertToast(displayMode: .hud, type: appModel.alert.type, title: appModel.alert.message)
				}
				.toast(isPresenting: $appModel.isLoading) {
					AlertToast(type: .loading)
				}
				Rectangle()
					.fill(Color.black.opacity(0.15))
					.frame(height: 1.0)
					.offset(CGSize(width: 0, height: -48.0))
				Rectangle()
					.fill(Color.buttonLink)
					.frame(width: geometry.size.width / 3, height: 2.0)
					.offset(CGSize(width: markerOffset, height: -47.0))
			}
			.ignoresSafeArea(.keyboard, edges: .bottom)
		}
	}

	func fetchMessages() {
		Task {
			do {
				try await messageCenter.fetch()
			} catch AppError.logout {
				DispatchQueue.main.async {
					appModel.alert = .error(message: "\(AppError.logout)")
				}
			} catch {
				print("\(error)")
			}
		}
	}
}

struct BaseTabView_Previews: PreviewProvider {
	static var previews: some View {
		BaseTabView()
			.environmentObject(AppModel())
	}
}
