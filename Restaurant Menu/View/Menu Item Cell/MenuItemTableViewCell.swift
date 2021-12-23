//
//  MenuItemTableViewCell.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {

    //MARK: Variables
    @IBOutlet weak var menuItemTitleLabel: UILabel!
    @IBOutlet weak var menuItemDescriptionLabel: UILabel!
    @IBOutlet weak var menuItemPriceLabel: UILabel!
    
    //MARK: - Awake
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
