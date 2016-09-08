//
//  RounderButton.swift
//  OnTheMap
//
//  Created by Jennifer Person on 8/7/16.
//  Copyright © 2016 Jennifer Person. All rights reserved.
//

import UIKit

// MARK: - RounderButton: Button

class RounderButton: UIButton {

    // MARK: Properties
    
    // styling
    let titleLabelFontSize: CGFloat = 17.0
    let borderedButtonHeight: CGFloat = 40.0
    let borderedButtonCornerRadius: CGFloat = 12.0
    var backingColor: UIColor? = nil
    var highlightedBackingColor: UIColor? = nil
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        lookRoundedButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lookRoundedButton()
    }
    
    private func lookRoundedButton() {
        layer.masksToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.blackColor().CGColor
        layer.cornerRadius = borderedButtonCornerRadius
        highlightedBackingColor = UIColor.darkGrayColor()
        backingColor = UIColor.grayColor()
        backgroundColor = UIColor.grayColor()
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        titleLabel?.font = UIFont.systemFontOfSize(titleLabelFontSize)
    }
    
    // MARK: Setters
    
    private func setBackingColor(newBackingColor: UIColor) {
        if let _ = backingColor {
            backingColor = newBackingColor
            backgroundColor = newBackingColor
        }
    }
    
    private func setHighlightedBackingColor(newHighlightedBackingColor: UIColor) {
        highlightedBackingColor = newHighlightedBackingColor
        backingColor = highlightedBackingColor
    }
    
    // MARK: Tracking
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent: UIEvent?) -> Bool {
        backgroundColor = highlightedBackingColor
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    // MARK: Layout
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        var sizeThatFits = CGSizeZero
        sizeThatFits.height = borderedButtonHeight
        return sizeThatFits
    }
}