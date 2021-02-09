//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by user on 07/02/2021.
//

import UIKit
import MapKit
import AVFoundation

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var infoMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       configure()
    }
    
    func configure(){
        setUIVisibility(isHidden: true)
        let cancelButton = UIButton(type: .system)
        let attributes: [NSAttributedString.Key: Any] = [
           .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 16)!,
        ]
        cancelButton.setAttributedTitle(NSAttributedString(string: "CANCEL", attributes: attributes), for: .normal)
        cancelButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        cancelButton.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    func setUIVisibility(isHidden status: Bool){
        infoMapView.isHidden = status
        finishButton.isHidden = status
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        setUIVisibility(isHidden: false)
    }
    
    @IBAction func finish(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
