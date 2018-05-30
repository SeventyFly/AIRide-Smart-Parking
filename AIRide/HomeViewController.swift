//
//  HomeViewController.swift
//  AIRide
//
//  Created by Oleh Komarnitsky on 28.04.2018.
//  Copyright © 2018 SeventyFly. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}

class HomeViewController:UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate {
    
//    @IBAction func handleLogout(_ sender:Any) {
//        try! Auth.auth().signOut()
//    }
    
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    var marker: GMSMarker!
    
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    
    var imgArray = Array(repeating: UIImage(), count: 10)
    var idArray = Array(repeating: Int(), count: 10)
    var titleArray = Array(repeating: String(), count: 10)
    var priceArray = Array(repeating: Int(), count: 10)
    var textArray = Array(repeating: String(), count: 10)
    var latArray = Array(repeating: Double(), count: 10)
    var longArray = Array(repeating: Double(), count: 10)
    var placesArray = Array(repeating: Int(), count: 10)
    var availablePlacesArray = Array(repeating: Int(), count: 10)
    var markersArray = Array(repeating: GMSMarker(), count: 10)
    var tappedMarkersArray = Array(repeating: GMSMarker(), count: 1)
    var markerOfPlaceArrivalArray = Array(repeating: GMSMarker(), count: 1)
    var userBalance = [Int]()
    var subviewArray = Array(repeating: UIButton(), count: 1)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func loadView() {
        super.loadView()
        getParkingsData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                myMapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Futura-CondensedExtraBold", size: 17) as Any, NSAttributedStringKey.foregroundColor:UIColor.white]
        self.title = "AIRide: паркуйся з комфортом"
        myMapView.delegate = self
    
        //  If we want to open app with user location
        //  locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        setupViews()
        
        initGoogleMaps()
                
        txtFieldSearch.delegate = self
    }
    
    // Get data from Firebase Database
    func getParkingsData() {
        let dbReference = Database.database().reference()

        let group = DispatchGroup()
        
        dbReference.child("parkings/").observe(.childAdded, with: { (snapshot) in
            group.enter()
            let value = snapshot.value as? NSDictionary
            let id = value?["id"] as? Int ?? 0
            let latitude = value?["latitude"] as? Double ?? 0
            let longitude = value?["longitude"] as? Double ?? 0
            let price = value?["price"] as? Int ?? 0
            let title = value?["title"] as? String ?? "none"
            let text = value?["text"] as? String ?? "none"
            let places = value?["places"] as? Int ?? 0
            let availablePlaces = value?["available_places"] as? Int ?? 0
            
            let addedParking = Parking(available_places: availablePlaces, id: id, latitude: latitude, longitude: longitude, places: places, price: price, title: title, text: text)
            
            self.idArray[id] = addedParking.id
            self.titleArray[id] = addedParking.title
            self.priceArray[id] = addedParking.price
            self.textArray[id] = addedParking.text
            self.latArray[id] = addedParking.latitude
            self.longArray[id] = addedParking.longitude
            self.placesArray[id] = addedParking.places
            self.availablePlacesArray[id] = addedParking.available_places
            self.getImages(id: addedParking.id)
            self.visualMarkers(id: addedParking.id)
            
            group.leave()
        })
        
        group.notify(queue: .main) {
            print("All callbacks are completed, let's visual our markers")
        }
        
        dbReference.child("parkings/").observe(.childChanged, with: { (snapshot) -> Void in
            let value = snapshot.value as? NSDictionary
            let id = value?["id"] as? Int ?? 0
            let availablePlaces = value?["available_places"] as? Int ?? 0
            
            self.availablePlacesArray[id] = availablePlaces
            self.updateMarker(id: id)
        })
    }
    
    // Get images from Firebase Storage
    func getImages(id: Int) {
        self.imgArray[id] = UIImage(named: "parking\(id)")!
        
//        If will need to get images from Firebase
//
//        let storageRef = Storage.storage().reference().child("parkings/parking\(id).jpg")
//        storageRef.getData(maxSize: 25 * 1024 * 1024) { data, error in
//            if error != nil {
//                print("Error with loading images from Firebase Storage.")
//            } else {
//                let image = UIImage(data: data!)
//                print("Image from parking on \(self.titleArray[id]) with ID: \(id) loaded.")
//                self.imgArray[id] = image!
//            }
//        }
        
    }
    
    // Visual our parking markers
    func visualMarkers(id: Int) {
        marker = GMSMarker()
        
        let customMarker = ParkingMarkerView(frame: CGRect(x: 0, y: 0, width: self.customMarkerWidth, height: self.customMarkerHeight), availablePlaces: self.availablePlacesArray[id], borderColor: UIColor.darkGray, tag: self.idArray[id])

        marker.iconView = customMarker
  
        marker.position = CLLocationCoordinate2D(latitude: self.latArray[id], longitude: self.longArray[id])
        marker.map = self.myMapView
        self.markersArray[id] = marker
    }
    
    // Update needed marker
    func updateMarker(id: Int) {
        let customMarker = ParkingMarkerView(frame: CGRect(x: 0, y: 0, width: self.customMarkerWidth, height: self.customMarkerHeight), availablePlaces: self.availablePlacesArray[id], borderColor: UIColor.darkGray, tag: self.idArray[id])
        self.markersArray[id].iconView = customMarker
    }
    
    // Delete needed marker
    func deleteMarker (id: Int) {
        self.markersArray[id].map = nil
    }
    
    // Textfield for searching arrival place
    // Type and choose place
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.secondaryTextColor = UIColor(white: 1, alpha: 0.5)
        autoCompleteController.primaryTextColor = UIColor.lightGray
        autoCompleteController.primaryTextHighlightColor = UIColor.gray
        autoCompleteController.tableCellBackgroundColor = UIColor.darkGray
        autoCompleteController.tableCellSeparatorColor = UIColor.lightGray
        autoCompleteController.tintColor = UIColor.lightGray
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
    }
    
    // After clicked textfield for searchind arrival place
    // Visual marker of arrival place
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
        myMapView.camera = camera
        txtFieldSearch.text = place.formattedAddress
        chosenPlace = MyPlace(name: place.formattedAddress!, lat: lat, long: long)
        self.tappedMarkersArray[0].map = nil
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress!)"
        marker.icon = UIImage(named: "usermarker")
        self.markerOfPlaceArrivalArray[0] = marker
        marker.map = myMapView
        
        self.dismiss(animated: true, completion: nil)
        
        let alert = UIAlertController(title: "Wanna find nearest available free parking place?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Let's find it", style: .default, handler: { (handler) in
            self.findParkingWithFreePlace(lat: marker.position.latitude, long: marker.position.longitude)
        }))
        
        alert.addAction(UIAlertAction(title: "Nope", style: .default, handler: { (hangler) in
            self.txtFieldSearch.text = nil
            self.txtFieldSearch.placeholder = "Нажміть для пошуку місця призначення"
            self.txtFieldSearch.backgroundColor = UIColor(red: 22/255, green: 29/255, blue: 38/255, alpha: 0.75)
            self.txtFieldSearch.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)
            self.txtFieldSearch.layer.borderColor = UIColor.white.cgColor
            self.txtFieldSearch.attributedPlaceholder = NSAttributedString(string: "Tap for searching your arrival place", attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)])
            self.txtFieldSearch.font = UIFont(name: "Futura-MediumItalic", size: 17)
            self.markerOfPlaceArrivalArray[0].map = nil
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Our function for find free places on parkings
    func findParkingWithFreePlace(lat: Double, long: Double) {
        let arrivalPlace = CLLocation(latitude: lat, longitude: long)
        
        var nearestFreeParking: [String: Int] = [:]

        for id in 1..<idArray.count {
            if availablePlacesArray[id] != 0 {
                nearestFreeParking["\(titleArray[id])"] = (Int(arrivalPlace.distance(from: (CLLocation(latitude: latArray[id], longitude: longArray[id])))))
                if id == idArray.count - 1 {
                    for (key, value) in nearestFreeParking {
                        if value == nearestFreeParking.values.min() {
                            for id in 1..<idArray.count {
                                if titleArray[id] == key {
                                    let alert = UIAlertController(title: "Nearest parkings with free place is on \(key) street in \(value) meters from you.", message: nil, preferredStyle: .alert)
                                    
                                    alert.addAction(UIAlertAction(title: "Let's go to parking", style: .default, handler: { (handler) in
                                        self.myMapView.animate(to: GMSCameraPosition.camera(withLatitude: self.latArray[id], longitude: self.longArray[id], zoom: 16.5))
                                        self.myMapView.selectedMarker = self.markersArray[id]
                                    }))
                                    
                                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (handler) in
                                        self.markerOfPlaceArrivalArray[0].map = nil
                                        self.tappedMarkersArray[0].map = nil
                                    }))
                                        
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // When problem with auto-complete
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error, can't auto-complete. \(error)")
    }
    
    // Cancel auto-complete
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Default position map when app launched
    func initGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: 49.842798, longitude: 24.027372, zoom: 15.0)
        self.myMapView.camera = camera
        self.myMapView.delegate = self
        self.myMapView.isMyLocationEnabled = true
    }
    
    // Problem with getting user's location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    // Click and choose your place arrival [Marker]
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.markerOfPlaceArrivalArray[0].map = nil
        self.tappedMarkersArray[0].map = nil
        txtFieldSearch.text = nil
        txtFieldSearch.backgroundColor = UIColor(red: 22/255, green: 29/255, blue: 38/255, alpha: 0.75)
        txtFieldSearch.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)
        txtFieldSearch.layer.borderColor = UIColor.white.cgColor
        txtFieldSearch.attributedPlaceholder = NSAttributedString(string: "Tap for searching your arrival place", attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)])
        txtFieldSearch.font = UIFont(name: "Futura-MediumItalic", size: 17)
        let tappedMarker = GMSMarker(position: coordinate)
        tappedMarker.title = "Here name of your arrival place"
        tappedMarker.icon = UIImage(named: "usermarker")
        tappedMarker.map = mapView
        self.tappedMarkersArray[0] = tappedMarker
        let alert = UIAlertController(title: "Wanna find nearest available free parking place?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Let's find it", style: .default, handler: { (handler) in
            self.findParkingWithFreePlace(lat: tappedMarker.position.latitude, long: tappedMarker.position.longitude)
        }))
        
        alert.addAction(UIAlertAction(title: "Nope", style: .default, handler: { (hangler) in
            self.tappedMarkersArray[0].map = nil
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // When clicked/tapped on marker(preview info about parking)
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        marker.tracksInfoWindowChanges = true
        guard let customMarkerView = marker.iconView as? ParkingMarkerView else { return nil }
        previewParkingViewController.setData(title: titleArray[customMarkerView.tag], img: imgArray[customMarkerView.tag], price: priceArray[customMarkerView.tag])
        
        self.view.addSubview(btnCloseWindow)
        btnCloseWindow.topAnchor.constraint(equalTo: view.topAnchor, constant: 240).isActive=true
        btnCloseWindow.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive=true
        btnCloseWindow.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnCloseWindow.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
        
        self.subviewArray[0] = btnCloseWindow
        return previewParkingViewController
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        for removeItem in subviewArray {
            removeItem.removeFromSuperview()
        }
    }
    
    // When clicked at title/street/avenue of preview parking(goes to more info about parking page)
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? ParkingMarkerView else { return }
        let tag = customMarkerView.tag
        parkingTapped(tag: tag)
    }
    
    // Getting user location right now
    @objc func btnMyLocationAction() {
        let location: CLLocation? = myMapView.myLocation
        if location != nil {
            myMapView.animate(toLocation: (location?.coordinate)!)
            
            let alert = UIAlertController(title: "Wanna find nearest available free parking place?", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Let's find it", style: .default, handler: { (handler) in
                self.findParkingWithFreePlace(lat: (location?.coordinate.latitude)!, long: (location?.coordinate.longitude)!)
            }))
            
            alert.addAction(UIAlertAction(title: "Nope", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            print("Can't get your location")
        }
    }
    
    // Getting user profile
    @objc func btnMyProfileAction() {
        let username: String = (Auth.auth().currentUser?.displayName)!
        let email: String = (Auth.auth().currentUser?.email)!
        let uid: String = (Auth.auth().currentUser?.uid)!
        let dbReference = Database.database().reference()
        var balance: Int = 0
        
        dbReference.child("users/").observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let userBalance = value?["balance"] as? Int ?? 0
            let id = value?["uid"] as? String ?? " "
            
            if (id == uid) {
                balance = userBalance
            }
        })
        let p = ProfileViewController()
        p.passedData = (username: username, email: email, balance: balance)
        self.navigationController?.pushViewController(p, animated: true)
    }
    
    // Function for control markers that are tapped
    @objc func parkingTapped(tag: Int) {
        let v = DetailsViewController()
        v.passedData = (title: titleArray[tag], img: imgArray[tag], price: priceArray[tag], text: textArray[tag], places: placesArray[tag], availablePlaces: availablePlacesArray[tag])
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    // Function for control markers that are tapped
    @objc func btnCloseWindowAction() {
        myMapView.selectedMarker = nil
    }
    
    // Function to get textfield for finding arrival place
    func setupTextField(textField: UITextField, img: UIImage){
        textField.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = img
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
    }
    
    // General views for app
    func setupViews() {
        view.addSubview(myMapView)
        myMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        myMapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        myMapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        myMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60).isActive=true
        
        self.view.addSubview(txtFieldSearch)
        
        if #available(iOS 11.0, *) {
            txtFieldSearch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive=true
        } else {
            txtFieldSearch.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
        }
        txtFieldSearch.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive=true
        txtFieldSearch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive=true
        txtFieldSearch.heightAnchor.constraint(equalToConstant: 35).isActive=true
        
        setupTextField(textField: txtFieldSearch, img: #imageLiteral(resourceName: "map"))
        
        previewParkingViewController = PreviewParkingViewController(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 100, height: 200))
        
        self.view.addSubview(btnMyLocation)
        btnMyLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive=true
        btnMyLocation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        btnMyLocation.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnMyLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
        
        self.view.addSubview(btnMyProfile)
        btnMyProfile.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive=true
        btnMyProfile.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive=true
        btnMyProfile.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnMyProfile.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
    }
    
    // Create/loading background map
    let myMapView: GMSMapView = {
        let v = GMSMapView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // UI textfield for finding arrival place
    let txtFieldSearch: UITextField = {
        let tf = UITextField()
        tf.layer.borderWidth = 2
        tf.layer.cornerRadius = 5
        tf.backgroundColor = UIColor(red: 22/255, green: 29/255, blue: 38/255, alpha: 0.75)
        tf.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)
        tf.layer.borderColor = UIColor.white.cgColor
        tf.attributedPlaceholder = NSAttributedString(string: "Tap for searching your arrival place", attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)])
        tf.font = UIFont(name: "Futura-MediumItalic", size: 17)
        tf.clipsToBounds = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // UI button for getting users location right now
    let btnMyLocation: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 23/255, green: 37/255, blue: 42/255, alpha: 1)
        btn.setImage(#imageLiteral(resourceName: "map_Pin"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.darkGray
        btn.imageView?.tintColor = UIColor.darkGray
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let btnMyProfile: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 23/255, green: 37/255, blue: 42/255, alpha: 1)
        btn.setImage(#imageLiteral(resourceName: "myProfile"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.darkGray
        btn.imageView?.tintColor = UIColor.darkGray
        btn.addTarget(self, action: #selector(btnMyProfileAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let btnCloseWindow: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        btn.backgroundColor = UIColor(red: 23/255, green: 37/255, blue: 42/255, alpha: 1)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.darkGray
        btn.imageView?.tintColor = UIColor.darkGray
        btn.addTarget(self, action: #selector(btnCloseWindowAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // Get preview parking info 
    var previewParkingViewController: PreviewParkingViewController = {
        let v = PreviewParkingViewController()
        return v
    }()
    
}

