//
//  BorderedButton.swift
//  OnTheMap
//
//  Created by Rob Fazio on 5/10/16.
//  Copied from Jarrod Parkes repo on Github.
//  Copyright © 2016 Rob Fazio. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedButton: UIButton {
    
    // MARK: IBInspectable
    
    @IBInspectable var backingColor: UIColor = UIColor.clearColor() {
        didSet {
            backgroundColor = backingColor
        }
    }
    
    @IBInspectable var highlightColor: UIColor = UIColor.clearColor() {
        didSet {
            if state == .Highlighted {
                backgroundColor = highlightColor
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 4.0 {
        didSet {
            layer.masksToBounds = true
            layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: Tracking
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent: UIEvent?) -> Bool {
        backgroundColor = highlightColor
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        backgroundColor = backingColor
    }
}