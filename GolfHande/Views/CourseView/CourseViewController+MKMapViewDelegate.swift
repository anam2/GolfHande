//
//  CourseViewController+MKMapViewDelegate.swift
//  GolfHande
//
//  Created by Admin on 4/28/23.
//
import MapKit

extension CourseViewController: MKMapViewDelegate {
    
    // For polyline.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polylineOverlay = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polylineOverlay)
            renderer.strokeColor = UIColor.white
            renderer.lineWidth = 3.0
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    // Annotation View Properties
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKPointAnnotation else {
            return nil
        }
        
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.isDraggable = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedAnnotation = view.annotation as? MKPointAnnotation
    }
    
    // Dragging pin annotation view.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        switch newState {
        case .starting:
            NSLog("Started")
        case .dragging:
            NSLog("Dragging")
        case .ending:
            NSLog("Ending")
            guard let lat = view.annotation?.coordinate.latitude,
                  let long = view.annotation?.coordinate.longitude else { return }
            let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
            addPolyline(coordinates: [teeBoxCoordinate, coordinates])
        case .none:
            break
        default:
            break
        }
    }
}
