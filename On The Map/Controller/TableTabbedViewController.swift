//
//  TableTabbedViewController.swift
//  On The Map
//
//  Created by user on 04/02/2021.
//

import UIKit
import FBSDKLoginKit

class TableTabbedViewController: UIViewController, HelperFunction {
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    private var authService: AuthService!
    let infoService: InfoService = InfoServiceImpl()
    var studentInfoList: [InformationModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // implementation
        let loginManager = LoginManager()
        authService = AuthServiceImpl(loginManager: loginManager)
        
        configureNavBar(navigationItem: self.navigationItem, logoutSelector: #selector(self.logout), locationSelector: #selector(self.addLocation), refreshSelector: #selector(self.refresh))
        
        configureRefreshIndicator()
        
        // notification observer update data when called
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateData), name: NSNotification.Name(rawValue: Constants.Notification.FetchNotifierIdentifier), object: nil)
        
        self.tableView.register(TabbedTableViewCell.nib(), forCellReuseIdentifier: TabbedTableViewCell.identifier)
        
        studentInfoList = InfoData.shared.studentInfoList
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateStudentLocation(results: Any?, error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                self.present(self.errorMessage(title: "Error", message: error.localizedDescription), animated: true)
            }
            self.tableView.refreshControl?.endRefreshing()
          }
    }
    
    @objc private func updateData() {
        studentInfoList = InfoData.shared.studentInfoList
        tableView.reloadData()
    }
    
    @objc private func addLocation() {
        performSegue(withIdentifier: Constants.SegueIdentifier.InfoPostingScreen, sender: nil)
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
        infoService.getAllStudentLocation(completionHandler: updateStudentLocation)
    }
    
    private func configureRefreshIndicator(){
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
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
        let url = studentInfoList[indexPath.row].url
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
