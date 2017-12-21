//
//  MapTest.swift
//  SuperVarioWohnen
//
//  Created by Sefa Kanbur on 29.11.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import MapKit
class MapTest: UIViewController, CLLocationManagerDelegate,UISearchBarDelegate,MKMapViewDelegate {

    @IBOutlet var naviCon: UINavigationItem!
    
    let searchBar = UISearchBar()
    @IBOutlet weak var route: UIBarButtonItem!
    @IBOutlet weak var filter: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    var myRoute : MKRoute!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableLocationServices()
        searchBar.placeholder="Placeholder"
        naviCon?.titleView = searchBar
        searchBar.delegate = self
        
        
 }

    let regionRadius: CLLocationDistance = 1000
    
    let locationManager = CLLocationManager()
    
    func enableLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
            
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
            
        }
    }
    
    @IBAction func makeRoute(_ sender: UIBarButtonItem) {
        
        
        let point1 = MKPointAnnotation()
        let point2 = MKPointAnnotation()
        
        point1.coordinate = CLLocationCoordinate2DMake(25.0305, 121.5360)
        point1.title = "Taipei"
        point1.subtitle = "Taiwan"
        mapView.addAnnotation(point1)
        
        point2.coordinate = CLLocationCoordinate2DMake(24.9511, 121.2358)
        point2.title = "Chungli"
        point2.subtitle = "Taiwan"
        mapView.addAnnotation(point2)
        mapView.centerCoordinate = point2.coordinate
        mapView.delegate=self
        
        mapView.setRegion(MKCoordinateRegionMake(point2.coordinate, MKCoordinateSpanMake(0.7,0.7)), animated: true)
        
        let directionsRequest = MKDirectionsRequest()
        
        let markTaipei = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
        
        let markChungli = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.source = MKMapItem(placemark: markChungli)
        directionsRequest.destination = MKMapItem(placemark: markTaipei)
        
        directionsRequest.transportType = MKDirectionsTransportType.automobile
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate(completionHandler: {
            
            response, error in
            
            if error != nil {
                print("Error getting directions")
            } else {
                
                for route in response!.routes {
                    
                    self.mapView.add(route.polyline,
                                level: MKOverlayLevel.aboveRoads)
                    for step in route.steps {
                        print(step.instructions)
                    }
                }
                
            }
        })

        
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        
        if let polyline = overlay as? MKPolyline {
            let testlineRenderer = MKPolylineRenderer(polyline: polyline)
            testlineRenderer.strokeColor = .red
            testlineRenderer.lineWidth = 2.0
            return testlineRenderer
        }
        fatalError("Something wrong...")
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        
        search.start { (response: MKLocalSearchResponse!, error: Error?) in
            let items = response.mapItems
            let placemarks = NSMutableArray()
            
            for item in items {
                placemarks.add(item.placemark)
            }
            

            self.mapView.showAnnotations(placemarks as! [MKAnnotation], animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.desiredAccuracy = kCLLocationAccuracyBest
            
            if CLLocationManager.locationServicesEnabled() {
                manager.startUpdatingLocation()
            }
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        centerMapOnLocation(location: userLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        //mapView.setRegion(MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.7,0.7)), animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
