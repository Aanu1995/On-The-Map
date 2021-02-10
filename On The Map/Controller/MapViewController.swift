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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    
    let locationManager = CLLocationManager()
    let authService = Authentication()
    let studentLocationService = StudentLocationClient()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // notification observer update data when called
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData), name: NSNotification.Name(rawValue: Constants.fetchNotifierIdentifier), object: nil)
        
        studentLocationService.getAllStudentLocation(completionHandler: updateStudentLocation)
        
        configureNavBar(navigationItem: self.navigationItem, logoutSelector: #selector(self.logout), locationSelector: #selector(self.addLocation), refreshSelector: #selector(self.refresh))
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateStudentLocation(results: Any?, error: Error?) {
        fetchingData(false)
        if let error = error {
            self.present(self.errorMessage(title: "Error", message: error.localizedDescription), animated: true)
        }
    }
    
    @objc func updateData() {
        
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
        refreshIndicator.startAnimating()
        studentLocationService.getAllStudentLocation(completionHandler: updateStudentLocation)
    }
    
    func fetchingData(_ isFetching: Bool){
        if isFetching {
            loadingIndicator.startAnimating()
        }else {
            loadingIndicator.stopAnimating()
            refreshIndicator.stopAnimating()
        }
        
        mapView.isHidden = isFetching
    }
}
