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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar(navigationItem: self.navigationItem, logoutSelector: #selector(self.logout), locationSelector: #selector(self.addLocation), refreshSelector: #selector(self.refresh))
        
        self.tableView.register(TabbedTableViewCell.nib(), forCellReuseIdentifier: TabbedTableViewCell.identifier)
        
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


extension TableTabbedViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TabbedTableViewCell.identifier, for: indexPath) as! TabbedTableViewCell
        
        cell.configure(title: "Owen LaRosa", subTitle: "https://www.github.com/Aanu1995", showDivider: indexPath.row < 3)
        
        return cell
    }
    
}
