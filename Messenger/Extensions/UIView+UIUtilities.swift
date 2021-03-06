//
//  UIView+CornerRadius.swift
//  Racing
//
//  Created by Pavel Akulenak on 20.05.21.
//

import UIKit

extension UIView {
    func addShadow(color: UIColor, opacity: Float, offSet: CGSize, radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }

    func addBorder(width: CGFloat, borderColor: UIColor) {
        layer.borderWidth = width
        layer.borderColor = borderColor.cgColor
    }
}
