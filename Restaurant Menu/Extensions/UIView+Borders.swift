//
//  UIView+Borders.swift
//  Restaurant Menu
//
//  Created by Diogo Lessa on 25/12/21.
//

import UIKit

extension UIView {
    func addTopBorder(with color: UIColor?, withWidth width: CGFloat, andBorderWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: width, height: borderWidth)
        addSubview(border)
    }

    func addBottomBorder(with color: UIColor?, withWidth width: CGFloat, andBorderWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: width, height: borderWidth)
        addSubview(border)
    }
}
