//
//  MapViewController.swift
//  Kiran_PadinhareKUnnoth_FE_8940891
//
//  Created by IS on 2023-12-10.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{
    //Location manager to handle user's location
    var locationManager=CLLocationManager()
    
    //mapview outlet
    @IBOutlet weak var map1: MKMapView!
    //coordinates for the destination and directions
    var destinationCoordinate: CLLocationCoordinate2D?
    var modeOfTravel : MKDirectionsTransportType = .automobile
    
    
    
    @IBAction func getCityName(_ sender: UIBarButtonItem) {
    
        // Show an alert to get the user's input for the city name
        let alert = UIAlertController(title: "Enter the city", message: " ", preferredStyle: .alert)
        
        alert.addTextField()
        alert.textFields![0].placeholder = "City Name"
        alert.textFields![0].keyboardType = UIKeyboardType.namePhonePad
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive,handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default ,handler: {(action) in
            let cityName = alert.textFields![0].text
            self.convertAddress(cityName: cityName!)
            
        }))
        
        self.present(alert, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //print (locations)
        if let location = locations.first {
            manager.startUpdatingLocation()
            render (location)
        }
    }
    
    //map rendering methods
    func render (_ location: CLLocation) {
        
       
        let coordinate = CLLocationCoordinate2D (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude )
        
        //span settings determine how much to zoom into the map - defined details
        
        let span = MKCoordinateSpan(latitudeDelta: 4.9, longitudeDelta: 4.9)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        
        let pin = MKPointAnnotation ()
        pin.coordinate = coordinate
        
        map1.addAnnotation(pin)
        map1.setRegion(region, animated: true)
    }
    func convertAddress(cityName : String) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(cityName) {
            (placemarks, error) in
            
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location
            else {
                print ("No location found")
                return
            }
            
            self.map1.removeAnnotations(self.map1.annotations)
            self.map1.removeOverlays(self.map1.overlays)
            //print(location)
            self.destinationCoordinate = location.coordinate
            //self.mapThis(desitiationCor: location.coordinate)
            self.mapThis()
        }
        
    }
    func mapThis(){
        
        let sourceCoordinate = (locationManager.location?.coordinate)!
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate!)
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        let destinationRequest = MKDirections.Request()
        
        //start and end
        
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem
        
        // the travel
        destinationRequest.transportType = modeOfTravel
        
        // one route = false multi = true
        destinationRequest.requestsAlternateRoutes = true
        
        
        // submit request to calculate directions
        let request = MKDirections.Request()
        request.source = sourceItem
        request.destination = destinationItem
        request.transportType = modeOfTravel
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            // if there is a response make it the response else make error
            guard let response = response else {
                if let error = error  {
                    print("something went wrong \(error)")
                }
                return
                
            }
            //we want the first response
            let route = response.routes[0]
            
            // adding overlay to routes
            self.map1.addOverlay(route.polyline)
            self.map1.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            // setting endpoint pin
            let pin = MKPointAnnotation()
            
            let coordinate = CLLocationCoordinate2D (latitude: self.destinationCoordinate!.latitude, longitude: self.destinationCoordinate!.longitude )
            
            pin.coordinate = coordinate
            pin.title = "END POINT"
            
            //calculate distance
            let distance = (route.distance) / 1000
            print(distance)
            
            self.map1.addAnnotation(pin)
            
        }
    }
    
    // Create a polyline overlay
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let routeline = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        //specify the rotueline based on the mode of travel used
        if(modeOfTravel == .automobile){
            routeline.strokeColor = .green
            routeline.lineWidth = 2.0
        }
        else if(modeOfTravel == .walking){
            routeline.strokeColor = .blue
            routeline.lineDashPattern = [3,10]
            routeline.lineWidth = 5.0
        }
        else if(modeOfTravel == .any){
            routeline.strokeColor = .red
            routeline.lineWidth = 5.0
        }
        
        return routeline
    }

    
    @IBOutlet weak var zoomSlider: UISlider!
    
    
    
    
    

    @IBAction func zoomInOut(_ sender: UISlider) {
        let miles = Double(sender.value)
            
        let delta = miles / 69.0

        var currentRegion = map1.region
        //change latitude and longitude to miles
        currentRegion.span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        map1.region = currentRegion
        //let (lat, long) = (currentRegion.center.latitude, currentRegion.center.longitude)
        //set the new span
        let span = MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta, longitudeDelta: currentRegion.span.longitudeDelta)
        let newRegion = MKCoordinateRegion(center: currentRegion.center, span: span)
        
        //set new region
        map1.setRegion(newRegion, animated: true)
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        map1.showsUserLocation = true
        locationManager.startUpdatingLocation()
        map1.delegate = self
        zoomSlider.minimumValue = 0.01
        zoomSlider.maximumValue = 1.0
        zoomSlider.value = 0.5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func byDrive(_ sender: UIButton) 
    {
        modeOfTravel = .automobile
        mapThis()

    }
    
    @IBAction func byCycle(_ sender: UIButton)
    {
        modeOfTravel = .any
        mapThis()

    }
    @IBAction func byWalk(_ sender: UIButton) 
    {
        modeOfTravel = .walking
        mapThis()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
