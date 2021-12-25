//
//  MenuSectionCollectionViewCell.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 23/12/21.
//

import UIKit

class MenuSectionCollectionViewCell: UICollectionViewCell {

    // MARK: - Variables
    @IBOutlet weak var menuSectionTitleLabel: UILabel!
    @IBOutlet weak var selectedSeparatorView: UIView!
    
    // MARK: - Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedSeparatorView.isHidden = true
    }
    
    override func prepareForReuse() -> Void {
        selectedSeparatorView.isHidden = true
        menuSectionTitleLabel.textColor = UIColor(named: "Darker Grey")
    }
}
