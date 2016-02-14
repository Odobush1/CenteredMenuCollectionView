//
//  UICollectionViewCell+Animations.swift
//  ODCenteredMenu
//
//  Created by Alex on 1/23/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import Foundation
import UIKit

let BoundsDeviation: Int32 = 100
let CellAnimationDuration = 1.0
let CellAnimationDelay = 0.0
let CellAnimationDamping: CGFloat = 0.7
let CellAnimationVelocity: CGFloat = 0.1

extension UICollectionViewCell {
    func performCellAnimation() {
        let startPoint = getRangomPoint()
        self.transform = CGAffineTransformMakeTranslation(startPoint.x, startPoint.y)
        self.alpha = 0.0
        
        UIView.animateWithDuration(CellAnimationDuration, delay: CellAnimationDelay, usingSpringWithDamping: CellAnimationDamping, initialSpringVelocity: CellAnimationVelocity, options: [.CurveEaseInOut, .BeginFromCurrentState], animations: { _ in
                self.transform = CGAffineTransformIdentity
                self.alpha = 1.0
            }, completion: nil)
    }
    
    func getRangomPoint() -> CGPoint {
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let screenHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)
        
        let randomY = rand() % Int32(Int(screenHeight) + BoundsDeviation)
        
        var randomX: Int32
        if randomY >= Int32(screenHeight) {
            randomX = rand() % Int32(screenWidth)
            return CGPointMake(CGFloat(randomX), CGFloat(randomY))
        }
        
        randomX = rand() % 2 == 1 ? (Int32(screenWidth) + BoundsDeviation) : -BoundsDeviation
        return CGPointMake(CGFloat(randomX), CGFloat(randomY))
    }
}