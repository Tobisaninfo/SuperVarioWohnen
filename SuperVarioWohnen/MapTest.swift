//
//  MapTest.swift
//  SuperVarioWohnen
//
//  Created by Sefa Kanbur on 29.11.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MapTest: UIViewController, CLLocationManagerDelegate,UISearchBarDelegate,MKMapViewDelegate,MKLocalSearchCompleterDelegate {


    @IBOutlet var naviCon: UINavigationItem!
    let searchBar = UISearchBar()
    @IBOutlet weak var mapView: MKMapView!
    var myLocation:CLLocation!
    
    var searchMode:Bool!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableLocationServices()
        searchBar.placeholder="Suchen..."
        naviCon?.titleView = searchBar
        searchBar.delegate = self
        searchMode=true
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
    

    
    @IBAction func route(_ sender: UIBarButtonItem) {
        searchMode=false
        searchBar.placeholder="Route..."
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        let pointAnnotation = MKPointAnnotation()
        search.start { (response: MKLocalSearchResponse!, error: Error?) in
           /* let items = response.mapItems

            if(!self.searchMode!){
                self.makeRoute(items: items)
            }
            else{
            let placemarks = NSMutableArray()
            
            for item in items {
                placemarks.add(item.placemark)
            }
            
            self.mapView.showAnnotations(placemarks as! [MKAnnotation], animated: true)
            }*/
            

            
            pointAnnotation.title = searchBar.text
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude:response!.boundingRegion.center.latitude, longitude: response!.boundingRegion.center.longitude)
            self.mapView.addAnnotation(pointAnnotation)
            if(self.searchMode){
                self.mapView.setRegion(MKCoordinateRegionMake(pointAnnotation.coordinate, MKCoordinateSpanMake(0.2,0.2)), animated: true)
            }
            else{
                self.routeShow(pointAnnotation: pointAnnotation)
            }
            
        }
        
        
        
    }
    
    func routeShow(pointAnnotation: MKPointAnnotation){
        
        let point1 = MKPointAnnotation()
        let point2 = pointAnnotation
        
        point1.coordinate = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude)
        mapView.addAnnotation(pointAnnotation)
        
        
        mapView.delegate=self
        
        let coordinate1=CLLocation(latitude:point1.coordinate.latitude,longitude: point1.coordinate.longitude)
        
        let coordinate2=CLLocation(latitude:point2.coordinate.latitude,longitude: point2.coordinate.longitude)
        
        let region = coordinate1.distance(from: coordinate2)
        
        let diff1=(point1.coordinate.latitude+point2.coordinate.latitude)/2
        let diff2=(point1.coordinate.longitude+point2.coordinate.longitude)/2
        let test=CLLocation(latitude:diff1,longitude: diff2)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(test.coordinate,region, region)
        mapView.setRegion(coordinateRegion, animated: true)
        
        let directionsRequest = MKDirectionsRequest()
        
        let source = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
        
        let target = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.source = MKMapItem(placemark: source)
        directionsRequest.destination = MKMapItem(placemark: target)
        
        directionsRequest.transportType = MKDirectionsTransportType.automobile
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate(completionHandler: {
            
            response, error in
            
            if error != nil {
                print("Error getting directions")
            } else {
                for route in response!.routes {
                    self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
                }
            }
        })
        searchMode=true
        
        searchBar.placeholder="Suchen..."
        
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
        myLocation=userLocation
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

