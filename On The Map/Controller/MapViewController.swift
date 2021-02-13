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

    let authService = Authentication()
    let studentInfoService = StudentInformationClient()
    var studentInfoList: [InformationModel] = []
    var currentMediaURL: String? = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // notification observer update data when called
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData), name: NSNotification.Name(rawValue: Constants.fetchNotifierIdentifier), object: nil)
        
        studentInfoService.getAllStudentLocation(completionHandler: updateStudentLocation)
        
        configureNavBar(navigationItem: self.navigationItem, logoutSelector: #selector(self.logout), locationSelector: #selector(self.addLocation), refreshSelector: #selector(self.refresh))
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updateStudentLocation(results: Any?, error: Error?) {
        fetchingData(false)
        if let error = error {
            self.present(self.errorMessage(title: "Error", message: error.localizedDescription), animated: true)
        }
    }
    
    @objc private func updateData() {
        studentInfoList = StudentInformation.studentLocationList
        
        // removed all the current annotations
        let currentAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(currentAnnotations)
        
        var annotaions = [MKPointAnnotation]()
        
        for info in studentInfoList {
            let annotation = MKPointAnnotation()
            annotation.title = "\(info.firstName) \(info.lastName)"
            annotation.subtitle = info.mediaURL
            annotation.coordinate = CLLocationCoordinate2D(latitude: info.latitude, longitude: info.longitude)
            
            annotaions.append(annotation)
        }
        self.mapView.addAnnotations(annotaions)
    }
    
    @objc private func addLocation() {
        performSegue(withIdentifier: Constants.infoPostingScreen, sender: nil)
    }
    
    @objc private func logout() {
        authService.logout { (error) in
            guard let error = error else {
               return self.dismiss(animated: true, completion: nil)
            }
            self.present(self.errorMessage(title: "Error", message: error.localizedDescription), animated: true)
        }
    }
    
    @objc private func refresh() {
        refreshIndicator.startAnimating()
        studentInfoService.getAllStudentLocation(completionHandler: updateStudentLocation)
    }
    
    private func fetchingData(_ isFetching: Bool){
        if isFetching {
            loadingIndicator.startAnimating()
        }else {
            loadingIndicator.stopAnimating()
            refreshIndicator.stopAnimating()
        }
        
        mapView.isHidden = isFetching
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView?.canShowCallout = true
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        currentMediaURL = (view.annotation!.subtitle ?? "") ?? ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onCalloutTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onCalloutTapped() {
        if let currentMediaURL = currentMediaURL {
            let url = URL(string: currentMediaURL.replacingOccurrences(of: " ", with: "%20"))!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
