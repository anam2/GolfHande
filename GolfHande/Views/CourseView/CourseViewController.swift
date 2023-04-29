//
//  CourseView.swift
//  GolfHande
//
//  Created by Andy Nam on 4/17/23.
//

import UIKit
import MapKit

class CourseViewController: UIViewController {
    var mapView = MKMapView(frame: .zero)
    let locationManager = CLLocationManager()
    
    var selectedAnnotation: MKPointAnnotation!
    var teeBoxGreenPolyline = MKPolyline()
    
    // Test Datas
    let teeBoxCoordinate = CLLocationCoordinate2D(latitude: 34.135868437816164, longitude: -118.28556251624518)
    let greenCoordinate = CLLocationCoordinate2D(latitude: 34.137293113674474, longitude: -118.28583607421989)
    
    // MARK: UI COMPONENTS:
    
    var currentDisplayText: String = "" {
        didSet {
            distanceLabel.text = currentDisplayText
        }
    }
    
    var distanceLabel: UILabel = {
        let distanceView = UILabel(frame: .zero)
        return distanceView
    }()
    
    // MARK: INIT
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable) required init? (coder aDecoder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationManager()
        setupMapView()
        setMapViewLocation(to: teeBoxCoordinate)

        addAnnotation(coordinate: teeBoxCoordinate)
        addAnnotation(coordinate: greenCoordinate)
        addPolyline(coordinates: [teeBoxCoordinate, greenCoordinate])

        setupUI()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.isUserInteractionEnabled = true
        mapView.mapType = .satellite
        mapView.showsUserLocation = true
    }
    
    private func setMapViewLocation(to centerCoordinate: CLLocationCoordinate2D) {
        // Sets the default zoom level.
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
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
        distanceLabel = UILabel(frame: CGRect(x: mapView.bounds.minX, y: mapView.bounds.minY, width: 100.0, height: 100.0))
        distanceLabel.textColor = .white
        mapView.addSubview(distanceLabel)
    }
    
    @objc private func mapViewTapped(_ sender: UITapGestureRecognizer) {
        let touch = sender.location(in: mapView)
        let coord = mapView.convert(touch, toCoordinateFrom: mapView)
        NSLog("MKMapView Clicked at cord: \(coord)")
    }
    
    private func addAnnotation(coordinate: CLLocationCoordinate2D) {
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        mapView.addAnnotation(pointAnnotation)
    }
    
    func addPolyline(coordinates: [CLLocationCoordinate2D]) {
        
        let startingCoordinate = coordinates[0]
        let endingCoordinate = coordinates[1]
        
        mapView.removeOverlay(teeBoxGreenPolyline)
        teeBoxGreenPolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(teeBoxGreenPolyline)
        
        let distanceString = getDistance(in: .yards, for: [startingCoordinate, endingCoordinate])
        self.distanceLabel.text = distanceString ?? ""
        
    }
    
    private func getDistance(in distanceType: DistanceType, for coordinates: [CLLocationCoordinate2D]) -> String? {
        guard coordinates.count == 2 else { return nil }
        let startingLocation = CLLocation(latitude: coordinates[0].latitude, longitude: coordinates[0].longitude)
        let endLocation = CLLocation(latitude: coordinates[1].latitude, longitude: coordinates[1].longitude)
        
        let distanceInMeters = startingLocation.distance(from: endLocation)
        
        switch distanceType {
        case .meters:
            return String(format: "%.0f", distanceInMeters)
        case .yards:
            return String(format: "%.0f", distanceInMeters * 1.09361)
        }
    }
    
    private func getAndSetCurrentLocationRegion() {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation,
                                            span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
            mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: LOCATION MANAGER DELEGATE

extension CourseViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            NSLog("Location permission granted.")
        case .denied:
            NSLog("Location permission denied.")
        default:
            break
        }
    }
}
