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
import MapKit
import SwiftUI

class ColorPolyline: MKPolyline {
	var color: TripDetails.Weight = .low
}

class ImageAnnotation: MKPointAnnotation {
	enum Category {
		case start
		case finish
	}

	let type: Category

	init(coordinate: CLLocationCoordinate2D, _ type: Category) {
		self.type = type
		super.init()
		self.coordinate = coordinate
	}
}

class SpeedAnnotation: MKPointAnnotation {
	let speed: Int
	let limit: Int

	init(coordinate: CLLocationCoordinate2D, speed: Int, limit: Int) {
		self.speed = speed
		self.limit = limit
		super.init()
		self.coordinate = coordinate
	}
}

class EventAnnotation: MKPointAnnotation {
	let type: TripDetails.Event.Category
	let value: Int

	init(coordinate: CLLocationCoordinate2D, _ value: Int,  _ type: TripDetails.Event.Category) {
		self.type = type
		self.value = value
		super.init()
		self.coordinate = coordinate
	}
}

class DistractedAnnotation: MKPointAnnotation {
	let type: TripDetails.Segment.Category
	let value: Int

	init(coordinate: CLLocationCoordinate2D, _ value: Int,  _ type: TripDetails.Segment.Category) {
		self.type = type
		self.value = value
		super.init()
		self.coordinate = coordinate
	}
}

class CustomMapView: MKMapView {
	/* prevent map from deselecting added annotation on tap  */
	var allowDeselection: Bool = true
	public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		if !allowDeselection, gestureRecognizer is UITapGestureRecognizer {
			return false
		}
		return true
	}
}

struct MapView: UIViewRepresentable {

	@Binding var mode: Int
	@Binding var details: TripDetails?

	class Coordinator: NSObject, MKMapViewDelegate {
		enum Mode: Int {
			case overview
			case distraction
			case eco
			case speed
		}

		var mapView: CustomMapView?
		var line: MKPolyline?
		var details: TripDetails?
		var mode: Mode = .overview
		var gestureRecognizer: UITapGestureRecognizer?
		var speedAnnotation: SpeedAnnotation?

		func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
			//print(mapView.centerCoordinate)
		}

		func mapView(_ mapView: MKMapView,
					 didUpdate userLocation: MKUserLocation) {}

		func mapViewWillStartLoadingMap(_ mapView: MKMapView) {}

		func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {}

		func mapViewWillStartLocatingUser(_ mapView: MKMapView) {}

		func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
			if let polyline = overlay as? ColorPolyline {
				let renderer = MKPolylineRenderer(overlay: overlay)
				renderer.lineWidth = 4
				switch polyline.color {
				case .high:
					renderer.strokeColor = .weightHigh
				case .medium:
					renderer.strokeColor = .weightMedium
				case .low:
					renderer.strokeColor = .weightLow
				}
				return renderer
			}

			if overlay is MKPolyline {
				let renderer = MKPolylineRenderer(overlay: overlay)
				renderer.lineWidth = 4
				renderer.strokeColor = .weightLow
				return renderer
			}

			fatalError("can't draw: \(overlay)")
		}

		func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
			let view: MKAnnotationView
			if let custom = annotation as? ImageAnnotation {
				switch custom.type {
				case .start:
					view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "start")
					view.image = UIImage(named: "Start")
					view.centerOffset = CGPoint(x: 0, y: 0)
				case .finish:
					view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "finish")
					view.image = UIImage(named: "Finish")
					view.centerOffset = CGPoint(x: 0, y: 0)
				}
			} else if let custom = annotation as? EventAnnotation {
				view = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
				view.image = .pinImages[custom.value]

				let stackView = UIStackView()
				stackView.axis = .vertical
				stackView.distribution = .fillEqually
				stackView.alignment = .fill

				let label1 = UILabel()
				let attribute: String
				switch custom.value {
				case 0:
					attribute = NSLocalizedString("txt_moderate", comment: "")
				case 1:
					attribute = NSLocalizedString("txt_fast", comment: "")
				default:
					attribute = NSLocalizedString("txt_extreme", comment: "")
				}

				let type: String

				switch custom.type {
				case .braking:
					type = NSLocalizedString("txt_braking", comment: "")
				case .acceleration:
					type = NSLocalizedString("txt_eco1", comment: "")
				case .cornering:
					type = NSLocalizedString("txt_cornering", comment: "")
				}

				label1.text = "\(attribute) \(type)"

				stackView.addArrangedSubview(label1)
				label1.font = .callout

				view.detailCalloutAccessoryView = stackView

			} else if let custom = annotation as? SpeedAnnotation {
				view = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)

				let stackView = UIStackView()
				stackView.axis = .vertical
				stackView.distribution = .fillEqually
				stackView.alignment = .fill

				let label1 = UILabel()
				label1.text = "\(NSLocalizedString("txt_current_speed", comment: "")) \(custom.speed) \(NSLocalizedString("txt_kmh", comment: ""))"
				stackView.addArrangedSubview(label1)
				label1.font = .callout

				let label2 = UILabel()
				label2.text = "\(NSLocalizedString("txt_speed_limit", comment: "")) \(custom.limit) \(NSLocalizedString("txt_kmh", comment: ""))"
				stackView.addArrangedSubview(label2)
				label2.font = .callout

				view.detailCalloutAccessoryView = stackView
				view.image = UIImage()
			} else if let custom = annotation as? DistractedAnnotation {
				view = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
				view.zPriority = .defaultSelected

				let stackView = UIStackView()
				stackView.axis = .vertical
				stackView.distribution = .fillEqually
				stackView.alignment = .fill

				let label1 = UILabel()

				switch custom.type {
				case .phone:
					view.image = UIImage(named: "Phone")
					label1.text = NSLocalizedString("alert_phone", comment: "")
				default:
					view.image = UIImage(named: "SwipeAndType")
					label1.text = NSLocalizedString("txt_distraction", comment: "")
				}

				stackView.addArrangedSubview(label1)
				label1.font = .callout

				let label2 = UILabel()
				label2.text = "\(custom.value) \(NSLocalizedString("txt_min", comment: ""))"
				stackView.addArrangedSubview(label2)
				label2.font = .callout

				view.detailCalloutAccessoryView = stackView

			} else {
				fatalError()
			}
			view.canShowCallout = true

			return view
		}

		func set(map: CustomMapView) {
			mapView = map
			map.delegate = self
		}

		@objc func tappedSpeedMap(recognizer: UITapGestureRecognizer) {
			guard let mapView = mapView, let details = details else { return }
			let location = recognizer.location(in: mapView)
			let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

			if let speedAnnotation = speedAnnotation {
				mapView.removeAnnotation(speedAnnotation)
			}

			let (target, coord) = Section.find(coordinate: coordinate, from: details)
			let loc = mapView.convert(coord, toPointTo: mapView)
			/* don't show annotation if pixel distance is high */
			let distanceSq = pow(loc.x - location.x, 2) + pow(loc.y - location.y, 2)

			if let target = target, distanceSq < 1024 {
				let annotation = SpeedAnnotation(coordinate: coord, speed: target.speed, limit: target.limit)
				mapView.addAnnotation(annotation)
				speedAnnotation = annotation
				mapView.selectAnnotation(annotation, animated: true)
			}
		}

		func set(mode: Int, details: TripDetails?) {
			guard let map = mapView, self.details != details || self.mode.rawValue != mode else { return }
			self.details = details
			self.mode = Mode(rawValue: mode) ?? .overview

			if let gestureRecognizer = gestureRecognizer {
				map.removeGestureRecognizer(gestureRecognizer)
				map.allowDeselection = true
			}

			map.removeOverlays(map.overlays)
			map.removeAnnotations(map.annotations)

			guard let details = details else { return }

			let overlays: [MKOverlay]
			let annotations: [MKAnnotation]
			switch self.mode {
			case .distraction:
				(annotations, overlays) = createDistractionOverlay(details: details)
			case .eco:
				(annotations, overlays) = createSafetyOverlay(details: details)
			case .speed:
				(annotations, overlays) = createSpeedOverlay(details: details)
				gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedSpeedMap(recognizer:)))
				if let gestureRecognizer = gestureRecognizer {
					map.addGestureRecognizer(gestureRecognizer)
					map.allowDeselection = false
				}
			default:
				(annotations, overlays) = createTotalOverlay(details: details)
			}

			map.addAnnotations(annotations)
			map.addOverlays(overlays, level: .aboveLabels)

			/* zoom overlay rect */
			guard let initial = map.overlays.first?.boundingMapRect else { return }

			let mapRect = map.overlays
				.dropFirst()
				.reduce(initial) { $0.union($1.boundingMapRect) }

			let insets = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
			map.setVisibleMapRect(mapRect, edgePadding: insets, animated: true)
		}

		func createTotalOverlay(details: TripDetails) -> ([MKAnnotation], [MKOverlay]) {
			var coordinates = details.locations.map { return $0.coordinate }
			var annotations: [MKAnnotation] = []

			let line = MKPolyline(coordinates: &coordinates, count: details.locations.count)
			self.line = line

			if let last = details.locations.last {
				annotations.append(ImageAnnotation(coordinate: last.coordinate, .finish))
			}

			if let first = details.locations.first {
				annotations.append(ImageAnnotation(coordinate: first.coordinate, .start))
			}

			return (annotations, [line])
		}

		func createSafetyOverlay(details: TripDetails) -> ([MKAnnotation], [MKOverlay]) {
			var (annotations, overlays) = createTotalOverlay(details: details)

			for event in details.events {
				let value = event.value > 1 ? (event.value > 3 ? 3 : event.value) : 1
				let annotation = EventAnnotation(coordinate: event.coordinate, value - 1, event.type)

				annotations.append(annotation)
			}
			return (annotations, overlays)
		}

		func createDistractionOverlay(details: TripDetails) -> ([MKAnnotation], [MKOverlay]) {
			var polylines: [MKPolyline] = []
			var annotations: [MKAnnotation] = []

			if let last = details.locations.last {
				annotations.append(ImageAnnotation(coordinate: last.coordinate, .finish))
			}

			if let first = details.locations.first {
				annotations.append(ImageAnnotation(coordinate: first.coordinate, .start))
			}

			if var segment = details.segments.first, let last = details.segments.last {
				var coordinates: [CLLocationCoordinate2D] = []
				var segmentIndex = 0

				func makeLine() {
					if !coordinates.isEmpty {
						let polyline = ColorPolyline(coordinates: &coordinates, count: coordinates.count)
						let idx = (coordinates.count - 1) / 2
						let coordinate = coordinates.count % 2 == 0 ? CLLocationCoordinate2D(
							latitude: (coordinates[idx].latitude + coordinates[idx+1].latitude) * 0.5,
							longitude: (coordinates[idx].longitude + coordinates[idx+1].longitude) * 0.5
						) : coordinates[idx]

						switch segment.type {
						case .undistracted:
							polyline.color = TripDetails.Weight.low
						default:
							polyline.color = TripDetails.Weight.high
							annotations.append(DistractedAnnotation(coordinate: coordinate, segment.duration, segment.type))
						}
						polylines.append(polyline)
					}
				}

				for location in details.locations {
					coordinates.append(location.coordinate)
					if location.timestamp > segment.end {
						makeLine()
						coordinates = [location.coordinate]
						segmentIndex += 1
						if segmentIndex < details.segments.count {
							segment = details.segments[segmentIndex]
						} else {
							segment = last
						}
					}
				}

				makeLine()
			}

			return (annotations, polylines)
		}

		func createSpeedOverlay(details: TripDetails) -> ([MKAnnotation], [MKOverlay]) {
			var polylines: [MKPolyline] = []
			var annotations: [MKAnnotation] = []

			var coordinates: [CLLocationCoordinate2D] = []
			var color = details.locations.first?.weight ?? .low

			func makeLine() {
				if !coordinates.isEmpty {
					let polyline = ColorPolyline(coordinates: &coordinates, count: coordinates.count)
					polyline.color = color
					polylines.append(polyline)
				}
			}

			for location in details.locations {
				coordinates.append(location.coordinate)
				if color != location.weight {
					makeLine()
					coordinates = [location.coordinate]
					color = location.weight
				}
			}

			makeLine()

			if let last = details.locations.last {
				annotations.append(ImageAnnotation(coordinate: last.coordinate, .finish))
			}

			if let first = details.locations.first {
				annotations.append(ImageAnnotation(coordinate: first.coordinate, .start))
			}

			return (annotations, polylines)
		}
	}

	let mapView = CustomMapView()

	init(mode: Binding<Int>, details: Binding<TripDetails?>) {
		_mode = mode
		_details = details
	}

	func makeCoordinator() -> Coordinator {
		Coordinator()
	}

	func makeUIView(context: Context) -> CustomMapView {
		context.coordinator.set(map: mapView)
		return mapView
	}

	func updateUIView(_ view: CustomMapView, context: Context) {
		context.coordinator.set(mode: mode, details: details)
	}
}
