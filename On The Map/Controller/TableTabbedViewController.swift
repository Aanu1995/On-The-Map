//
//  TableTabbedViewController.swift
//  On The Map
//
//  Created by user on 04/02/2021.
//

import UIKit

class TableTabbedViewController: UIViewController, HelperFunction {

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    let authService = Authentication()
    let studentLocationService = StudentLocationClient()
    
    var studentInfoList: [InformationModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentInfoList = StudentInformation.studentLocationList
        
        // notification observer update data when called
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData), name: NSNotification.Name(rawValue: Constants.fetchNotifierIdentifier), object: nil)
        
        configureNavBar(navigationItem: self.navigationItem, logoutSelector: #selector(self.logout), locationSelector: #selector(self.addLocation), refreshSelector: #selector(self.refresh))
        
        self.tableView.register(TabbedTableViewCell.nib(), forCellReuseIdentifier: TabbedTableViewCell.identifier)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateData() {
        studentInfoList = StudentInformation.studentLocationList
        tableView.reloadData()
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
        studentLocationService.getAllStudentLocation(completionHandler: updateStudentLocation)
    }
    
    func updateStudentLocation(results: Any?, error: Error?) {
        if let error = error {
            self.present(self.errorMessage(title: "Error", message: error.localizedDescription), animated: true)
        }
    }

}


extension TableTabbedViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TabbedTableViewCell.identifier, for: indexPath) as! TabbedTableViewCell
        
        let studentInfo = studentInfoList[indexPath.row]
        cell.configure(info: studentInfo, showDivider: (indexPath.row + 1) < studentInfoList.count )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: studentInfoList[indexPath.row].mediaURL)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
