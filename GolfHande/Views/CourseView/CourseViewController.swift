//
//  CourseView.swift
//  GolfHande
//
//  Created by Andy Nam on 4/17/23.
//

import UIKit
import MapKit

class CourseViewController: UIViewController {
    
    var mapView: MKMapView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable) required init? (coder aDecoder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up MapView
        mapView = MKMapView(frame: .zero)
        mapView.delegate = self
        mapView.isUserInteractionEnabled = true
        
        // Adding Views
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

extension CourseViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            let lat = annotation.coordinate.latitude
            let long = annotation.coordinate.longitude
            print("LAT: \(lat)\nLONG: \(long)")
        }
    }
}
