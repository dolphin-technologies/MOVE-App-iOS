//
// https://www.appcoda.com/animate-gradient-swiftui/
//

import SwiftUI

struct AnimatableGradientModifier: AnimatableModifier {
	let fromGradient: Gradient
	let toGradient: Gradient
	var progress: CGFloat = 0.0

	var animatableData: CGFloat {
		get { progress }
		set { progress = newValue }
	}

	func body(content: Content) -> some View {
		var gradientColors = [Color]()

		for i in 0..<fromGradient.stops.count {
			let fromColor = UIColor(fromGradient.stops[i].color)
			let toColor = UIColor(toGradient.stops[i].color)

			gradientColors.append(colorMixer(fromColor: fromColor, toColor: toColor, progress: progress))
		}

		return LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom)
	}

	func colorMixer(fromColor: UIColor, toColor: UIColor, progress: CGFloat) -> Color {
		guard let fromColor = fromColor.cgColor.components else { return Color(fromColor) }
		guard let toColor = toColor.cgColor.components else { return Color(toColor) }

		let red = fromColor[0] + (toColor[0] - fromColor[0]) * progress
		let green = fromColor[1] + (toColor[1] - fromColor[1]) * progress
		let blue = fromColor[2] + (toColor[2] - fromColor[2]) * progress

		return Color(red: Double(red), green: Double(green), blue: Double(blue))
	}

// hue rotation: 
//	func colorMixer(fromColor: UIColor, toColor: UIColor, progress: CGFloat) -> Color {
//		var hsb0 = fromColor.simdHSB
//		var hsb1 = toColor.simdHSB
//
//		/* rotate the other direction */
//		hsb0.x -= 1.0
//		let out = hsb0 * Float(1.0 - progress) + hsb1 * Float(progress)
//
//		return Color(hue: CGFloat(out.x), saturation: CGFloat(out.y), brightness: CGFloat(out.z), opacity: CGFloat(out.w))
//	}
}

extension View {
	func animatableGradient(fromGradient: Gradient, toGradient: Gradient, progress: CGFloat) -> some View {
		self.modifier(AnimatableGradientModifier(fromGradient: fromGradient, toGradient: toGradient, progress: progress))
	}
}

//extension UIColor {
//
//	var simdHSB: SIMD4<Float> {
//		var hue: CGFloat = 0
//		var saturation: CGFloat = 0
//		var brightness: CGFloat = 0
//		var alpha: CGFloat = 0
//
//		getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
//
//		return SIMD4(Float(hue), Float(saturation), Float(brightness), Float(alpha))
//	}
//}
