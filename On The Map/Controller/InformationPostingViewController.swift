//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by user on 07/02/2021.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, HelperFunction {
    
    // MARK: Outlets
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var infoMapView: MKMapView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    // MARK: Properties
    
    let infoService: InfoService = InfoServiceImpl()
    private var locationCoord: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure(){
        self.title = "Add Location"
        setUIVisibility(isHidden: true)
        
        // code to configure cancel button
        let cancelButton = UIButton(type: .system)
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 16)!]
        cancelButton.setAttributedTitle(NSAttributedString(string: "CANCEL", attributes: attributes), for: .normal)
        cancelButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        cancelButton.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    private func setUIVisibility(isHidden status: Bool){
        infoMapView.isHidden = status
        finishButton.isHidden = status
    }
    
    private func isLoading(_ isLoading: Bool){
        if isLoading {
            loadingIndicator.startAnimating()
        }else {
            loadingIndicator.stopAnimating()
        }
        // if start animating, disable the buttons, else enable them
        findLocationButton.isEnabled = !isLoading
        finishButton.isEnabled = !isLoading
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        let location = locationTextField.text ?? ""
        let link = urlTextField.text ?? ""

        // validates fields and return error message if validation failed
        if(location.isEmpty){
            return present(errorMessageDisplay(title: "Error", message: .locationError), animated: true)
        }
        else if (!isValidURL(link)){
           return present(errorMessageDisplay(title: "Error", message: .linkError), animated: true)
        }

        // show loading Indicator while searching for the location on map
        isLoading(true)

        let searchRequest =  MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = location

        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: onLocationSearchAvailable)
    }
    
    @IBAction func finish(_ sender: Any) {
        isLoading(true)
        // get the public user data and post location
        infoService.getUserData(completionHandler: onUserdataAvailable)
    }
    
    private func onLocationSearchAvailable(response: MKLocalSearch.Response?, error: Error?){
        // hide loading indicator
        isLoading(false)
        
        guard let response = response else {
            return self.present(self.errorMessage(title: "Error", message: error!.localizedDescription), animated: true)
        }
        
        self.locationCoord = response.boundingRegion.center
        
        let annotation = MKPointAnnotation()
        annotation.title = locationTextField.text
        annotation.coordinate = self.locationCoord!
        
        // show the location on the map
        setUIVisibility(isHidden: false)
        
        self.infoMapView.setCenter(self.locationCoord!, animated: true)
        self.infoMapView.addAnnotation(annotation)
    }
    
    private func onUserdataAvailable(user: User?, error: Error?) {
        if let error = error {
            isLoading(false)
            return self.present(self.errorMessage(title: "Error", message: error.localizedDescription), animated: true)
        }
        
        if let user = user {
            // student location object
            let studentLocation = StudentLocation(firstName:user.firstName, lastName: user.lastName, longitude: locationCoord!.longitude, latitude: locationCoord!.latitude, mediaURL: urlTextField.text!, mapString: locationTextField.text!, uniqueKey: user.uniqueKey)
            
            infoService.postStudentLocation(studentLocation: studentLocation, completionHandler: onLocationPostFeedback)
        }
    }
    
    private func onLocationPostFeedback(error: Error?){
        isLoading(false)
        if let error = error {
            return self.present(self.errorMessage(title: "Error", message: error.localizedDescription), animated: true)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}




extension InformationPostingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension InformationPostingViewController: MKMapViewDelegate {
    
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
}

