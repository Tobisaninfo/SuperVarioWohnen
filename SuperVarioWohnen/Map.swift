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
class Map: UIViewController, CLLocationManagerDelegate,UISearchBarDelegate,MKMapViewDelegate,UIGestureRecognizerDelegate, MKLocalSearchCompleterDelegate,UITableViewDelegate, UITableViewDataSource {


    @IBOutlet var naviCon: UINavigationItem!
    let searchBar = UISearchBar()
    var tableView: UITableView!
    var routeView: UIView!
    let dataSource: UITableViewDataSource! = nil
    @IBOutlet weak var mapView: MKMapView!
    var myLocation:CLLocation!
    let annotation = MKPointAnnotation()
    let pointAnnotation = MKPointAnnotation()
    var searchMode:Bool!
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableLocationServices()
        searchBar.placeholder="Suchen..."
        naviCon?.titleView = searchBar
        searchMode=true
        mapView.delegate=self
        initTableView()
        initGesture()
        initView()
        searchBar.showsCancelButton=true
        searchCompleter.delegate = self
        searchBar.delegate = self
    }
    
    func initGesture(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(shortTap))
        let longGestureRec = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.addGestureRecognizer(longGestureRec)
        gestureRecognizer.delegate = self
        longGestureRec.delegate=self
    }
    
    func initTableView(){
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    func initView(){
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = 1000.0
        routeView = UIView(frame: CGRect(x: 0, y: barHeight+100, width: displayWidth, height: displayHeight))
        self.view.addSubview(routeView)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.text=searchResults[indexPath.row].title
        tableView.removeFromSuperview()
        searching()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        let address = searchResults[indexPath.row]
        
        cell.textLabel!.text = address.title
        return cell
    }
    
    @objc func longTap(sender: UILongPressGestureRecognizer) {
        clearMap()
        
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        annotation.coordinate = coordinate
        annotation.title = "Auswahl"
        mapView.addAnnotation(annotation)
        routeShow(point2: annotation)
    }
    
    @objc func shortTap(sender: UITapGestureRecognizer) {
        clearMap()
    }
    func clearMap(){
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotation(pointAnnotation)
        if(annotation.coordinate.latitude != 0.0 && annotation.coordinate.longitude != 0.0){
            mapView.removeAnnotation(annotation)
        }
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
        if(searchMode){
            searchMode=false
            searchBar.placeholder="Route..."
        }
        else{
            searchMode=true
            searchBar.placeholder="Suchen..."
        }
        if(searchBar.text != ""){
            searching()
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.view.addSubview(tableView)
        searchCompleter.queryFragment = searchText
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.removeFromSuperview()
        searchBar.text=""
        clearMap()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searching()
    }

    
    func searching(){
        tableView.removeFromSuperview()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response: MKLocalSearchResponse!, error: Error?) in
            self.pointAnnotation.title = self.searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude:response!.boundingRegion.center.latitude, longitude: response!.boundingRegion.center.longitude)
            self.mapView.addAnnotation(self.pointAnnotation)
            if(self.searchMode){
                self.mapView.setRegion(MKCoordinateRegionMake(self.pointAnnotation.coordinate, MKCoordinateSpanMake(0.2,0.2)), animated: true)
            }
            else{
                self.routeShow(point2: self.pointAnnotation)
            }
        }
    }
    
    
    func routeShow(point2: MKPointAnnotation){
        
        let point1 = MKPointAnnotation()
        
        point1.coordinate = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude)

        setRegionBetween(point1: point1, point2: point2)
        
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
                    print("Strecke: \(route.distance/1000)km")
                    print("Zeit: \(route.expectedTravelTime/3600)std")
                    break
                }
                
            }
        })
    }
    
    func setRegionBetween(point1: MKPointAnnotation, point2: MKPointAnnotation){
        let coordinate1=CLLocation(latitude:point1.coordinate.latitude,longitude: point1.coordinate.longitude)
        let coordinate2=CLLocation(latitude:point2.coordinate.latitude,longitude: point2.coordinate.longitude)
        let region = coordinate1.distance(from: coordinate2)
        let diff1=(coordinate1.coordinate.latitude+coordinate2.coordinate.latitude)/2
        let diff2=(coordinate1.coordinate.longitude+coordinate2.coordinate.longitude)/2
        let test=CLLocation(latitude:diff1,longitude: diff2)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(test.coordinate,region, region)
        mapView.setRegion(coordinateRegion, animated: true)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

