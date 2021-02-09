//
//  MapViewController.swift
//  On The Map
//
//  Created by user on 04/02/2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController, HelperFunction{
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    
    let locationManager = CLLocationManager()
    let authService = Authentication()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar(navigationItem: self.navigationItem, logoutSelector: #selector(self.logout), locationSelector: #selector(self.addLocation), refreshSelector: #selector(self.refresh))
    }
    
    @objc func addLocation() {
        performSegue(withIdentifier: "InfoPostingScreen", sender: nil)
    }
    
    @objc func logout() {
        authService.logout { (error) in
            guard let error = error else {
               return self.dismiss(animated: true, completion: nil)
            }
            self.present(self.errorMessage(title: "Error", message: error.localizedDescription), animated: true)
        }
    }
    
    @objc func refresh() {
      
    }
}
