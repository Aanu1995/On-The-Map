//
//  TabbedTableViewCell.swift
//  On The Map
//
//  Created by user on 05/02/2021.
//

import UIKit

class TabbedTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var subTitleLabelView: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var divider: UIView!
    
    static let identifier = "TabbedTableViewCell"
    
   
    
    static func nib() -> UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    
    func configure(info: InformationModel, showDivider: Bool){
        self.titleLabelView.text = "\(info.firstName) \(info.lastName)"
        self.subTitleLabelView.text = info.mediaURL
        self.divider.isHidden = !showDivider
    }
}
