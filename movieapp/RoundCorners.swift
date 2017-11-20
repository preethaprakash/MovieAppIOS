//
//  RoundCorners.swift
//  movieapp
//
//  Created by preetha on 24/10/16.
//  Copyright © 2016 preetha. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}



