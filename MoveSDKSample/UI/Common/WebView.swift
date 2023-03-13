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

import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
	typealias UIViewType = WKWebView

	let url: URL

	init(config: String) {
		guard let path: String = RemoteConfiguration.shared[config], let url = URL(string: path) else {
			fatalError("could not load webview: \(config)")
		}
		self.url = url
	}

	init(url: URL) {
		self.url = url
	}

	func makeUIView(context: Context) -> WKWebView {
		WKWebView(frame: .zero)
	}

	func updateUIView(_ uiView: WKWebView, context: Context) {
		let request = URLRequest(url: url)
		uiView.load(request)
	}
}
