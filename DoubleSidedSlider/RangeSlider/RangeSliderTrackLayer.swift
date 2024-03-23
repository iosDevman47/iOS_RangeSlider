//
//  RangeSliderTrackLayer.swift
//  DoubleSidedSlider
//
//  Created by Alex Nasulloev on 22/03/24.
//

import Foundation
import UIKit

class RangeSliderTrackLayer: CALayer {
    
    var rangeSlider: RangeSliderProperties?
    
    override func draw(in ctx: CGContext) {
        
        if let slider = rangeSlider {
            // Clip
            let cornerRadius = bounds.height * slider.roundness / 2.0
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            ctx.addPath(path.cgPath)
            
            // Fill the track
            ctx.setFillColor(slider.outIntervalTrackColor.cgColor)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
            
            // Fill the highlighted range
            ctx.setFillColor(slider.inIntervalTrackColor.cgColor)
            let lowerValuePosition = CGFloat(slider.positionForValue(value: Double(slider.lowerValue)))
            let upperValuePosition = CGFloat(slider.positionForValue(value: Double(slider.upperValue)))
            let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
            ctx.fill(rect)
        }
    }
}
