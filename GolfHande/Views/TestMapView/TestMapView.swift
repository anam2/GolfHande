//
//  TestMapView.swift
//  GolfHande
//
//  Created by Admin on 4/28/23.
//

import Foundation
import MapKit

class TestMapViewController: UIViewController {
    var mapView = MKMapView(frame: .zero)
    var annotationView = MKAnnotationView()

    // Test Datas
    let teeBoxCoordinate = CLLocationCoordinate2D(latitude: 34.135868437816164, longitude: -118.28556251624518)
    let greenCoordinate = CLLocationCoordinate2D(latitude: 34.137293113674474, longitude: -118.28583607421989)

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable) required init? (coder aDecoder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        addAnnotation()
        setMapViewLocation(to: teeBoxCoordinate)
        setupMapView()
        setupUI()
    }

    private func setMapViewLocation(to centerCoordinate: CLLocationCoordinate2D) {
        // Sets the default zoom level.
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.mapType = .satellite
    }

//    func addLongPressGesture() {
//        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
//        longPressRecogniser.minimumPressDuration = 0.25
//        mapView.addGestureRecognizer(longPressRecogniser)
//    }
//
//    @objc func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
//        guard gestureRecognizer.state == .began else {
//            return
//        }
//        let touchPoint = gestureRecognizer.location(in: mapView)
//        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
//        print(touchMapCoordinate)
//    }

    private func addAnnotation() {
        let testPointAnnotation = MKPointAnnotation()
        testPointAnnotation.coordinate = greenCoordinate
        mapView.addAnnotation(testPointAnnotation)
    }

    private func setupUI() {
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }

}

extension TestMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        guard let annotationView = annotationView else { return nil }
        annotationView.isDraggable = true
        annotationView.addObserver(self,
                                    forKeyPath: "center",
                                    context: nil)
        self.annotationView = annotationView
        return annotationView
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let position = self.annotationView.center
        let coordinate = mapView.convert(position, toCoordinateFrom: mapView.superview)
        print(coordinate)
    }
}
