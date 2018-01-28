//
//  Map.swift
//  SuperVarioWohnen
//
//  Created by Sefa Kanbur on 29.11.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class Map: UIViewController, CLLocationManagerDelegate,UISearchBarDelegate,MKMapViewDelegate,UIGestureRecognizerDelegate, MKLocalSearchCompleterDelegate,UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var gobySwitch: UIBarButtonItem!
    @IBOutlet var naviCon: UINavigationItem!
    let searchBar = UISearchBar()
    var tableView: UITableView!
    @IBOutlet weak var timeRoute: UILabel!
    @IBOutlet weak var popupView: UIView!
    var routeView: UIView!
    let dataSource: UITableViewDataSource! = nil
    @IBOutlet weak var mapView: MKMapView!
    var myLocation:CLLocation!
    let annotation = MKPointAnnotation()
    var pointAnnotation = MKPointAnnotation()
    var searchMode:Bool!
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var directType = MKDirectionsTransportType.automobile
    var dist:Double!
    var time:Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        enableLocationServices()
        searchBar.placeholder="Suchen..."
        naviCon?.titleView = searchBar
        searchMode=true
        mapView.delegate=self
        initTableView()
        initGesture()
        initPopupView()
        searchBar.showsCancelButton=false
        searchCompleter.delegate = self
        searchBar.delegate = self
        //timeRoute!.text!="test" //Label text ist nil






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

    func initPopupView(){
        let screen = UIScreen.main
        let height = screen.bounds.size.height
        let width = screen.bounds.size.width
        popupView.frame.size.height = popupView.frame.size.height-13
        let popupHeight = popupView.frame.size.height
        popupView.frame.size.width = width

        let tabHeight = tabBarController?.tabBar.frame.size.height

        let y = height-(popupHeight+tabHeight!)
        popupView.frame.origin.y=y

        timeRoute.frame.size.width=width
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
        pointAnnotation=annotation
        if(myLocation != nil){
            routeShow()
        }
        else{
            print("Kein Standort")
        }
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
        popupView.isHidden=true

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
            searchBar.showsCancelButton=true
        }
        else{
            searchMode=true
            searchBar.placeholder="Suchen..."
            popupView.isHidden=true
        }
        if(searchBar.text != ""){
            searching()
        }

    }

    @IBAction func switchDirect(_ sender: UIBarButtonItem) {
        if(directType.isSubset(of: MKDirectionsTransportType.automobile)){
            directType = MKDirectionsTransportType.walking
            gobySwitch.image=#imageLiteral(resourceName: "car")
        }
        else{
            directType = MKDirectionsTransportType.automobile
            gobySwitch.image=#imageLiteral(resourceName: "walk")
        }
        mapView.removeOverlays(mapView.overlays)
        routeShow()
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
        popupView.isHidden=true
    }


    func searching(){
        self.searchBar.endEditing(true)
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
                if(self.myLocation != nil){
                    self.routeShow()
                }
                else{
                    print("Kein Standort")
                }
            }
        }
    }
    func showTime(){
        popupView.isHidden=false
        var cacheDist:String!
        var cacheTime:String!
        if(dist>999){
            cacheDist="\(round(dist/1000)) km "
        }
        else{
            cacheDist="\(round(dist)) m "
        }
        if((time/60)>59){
            var min=time/3600
            var hours=0
            while(min>=1){
                min=min-1
                hours=hours+1
            }
            min=min*60
            cacheTime="(\(hours) std \(round(min)) min)"
        }
        else{
            cacheTime="(\(round(time/60)) min)"
        }
        timeRoute.text=cacheDist+cacheTime
    }

    func routeShow(){

        let point1 = MKPointAnnotation()
        let point2 = pointAnnotation
        point1.coordinate = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude)

        setRegionBetween(point1: point1, point2: point2)



        let source = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)

        let target = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)

        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = MKMapItem(placemark: source)
        directionsRequest.destination = MKMapItem(placemark: target)

        directionsRequest.transportType = directType


        let directions = MKDirections(request: directionsRequest)
        directions.calculate(completionHandler: {
            response, error in
            if error != nil {
                print("Error getting directions")
            } else {

                for route in response!.routes {
                    self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
                    self.dist=route.distance
                    self.time=route.expectedTravelTime
                    self.showTime()
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
