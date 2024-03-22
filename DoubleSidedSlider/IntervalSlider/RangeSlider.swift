//
//  RangeSlider.swift
//  DoubleSidedSlider
//
//  Created by Alex Nasulloev on 19/03/24.
//

import Foundation
import QuartzCore
import UIKit

protocol RangeSliderProperties {
    var minimumValue: Float { get set }
    var maximumValue: Float { get set }
    var lowerValue: Float { get set }
    var upperValue: Float { get set }
    
    var inIntervalTrackColor: UIColor { get set }
    var outIntervalTrackColor: UIColor { get set }
    var roundness: CGFloat { get set }
    
    var thumbTintColor: UIColor { get set }
    
    var lowerThumbImage: UIImage? { get set }
    var upperThumbImage: UIImage? { get set }
    var activeLowerThumbImage: UIImage? { get set }
    var activeUpperThumbImage: UIImage? { get set }
    
    func setValue(lowerValue: Float, upperValue: Float, animate: Bool)
    
    func positionForValue(value: Double) -> Double
}

class RangeSlider: UIControl {
    
    var minimumValue: Float = 0 {
        didSet {
            updateLayerFrames()
        }
    }
    var maximumValue: Float = 0 {
        didSet {
            updateLayerFrames()
        }
    }
    var lowerValue: Float = 0 {
        didSet {
            updateLayerFrames()
        }
    }
    var upperValue: Float = 0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var thumbTintColor: UIColor = .systemBlue
    
    var lowerThumbImage: UIImage? = nil
    var upperThumbImage: UIImage? = nil
    var activeLowerThumbImage: UIImage? = nil
    var activeUpperThumbImage: UIImage? = nil
    
    private let trackLayer = RangeSliderTrackLayer()
    private let lowerThumb = RangeSliderThumb()
    private let upperThumbLayer = RangeSliderThumb()

    private var curvaceousness : CGFloat = 1.0
    
    private var previousLocation = CGPoint()
    
    private var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    var trackHighlightTintColor: UIColor = .systemBlue
    var trackTintColor: UIColor = .clear
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        lowerThumb.rangeSlider = self
        addSubview(lowerThumb)
        
        upperThumbLayer.rangeSlider = self
        addSubview(upperThumbLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerFrames()
        setupThumbs()
    }
    
    private func setupThumbs() {
        lowerThumb.activeImage = activeLowerThumbImage
        lowerThumb.inactiveImage = lowerThumbImage
        
        upperThumbLayer.activeImage = activeUpperThumbImage
        upperThumbLayer.inactiveImage = upperThumbImage
        
        lowerThumb.setImage(lowerThumbImage)
        upperThumbLayer.setImage(upperThumbImage)
    }
    
    private func updateLayerFrames() {
        
        guard frame != CGRect(x: 0, y: 0, width: 0, height: 0) else { return }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(value: Double(lowerValue)))
        lowerThumb.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
        
        let upperThumbCenter = CGFloat(positionForValue(value: Double(upperValue)))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
        
        CATransaction.commit()
    }
    
    func positionForValue(value: Double) -> Double {
        var result = Double()
        result = bounds.width - thumbWidth
        result *= (value - Double(minimumValue))
        result /= Double((maximumValue - minimumValue))
        result += Double(thumbWidth / 2.0)
        return result
    }
    
}

extension RangeSlider: RangeSliderProperties {
    
    var inIntervalTrackColor: UIColor {
        get {
            trackHighlightTintColor
        }
        set {
            trackHighlightTintColor = newValue
            trackLayer.setNeedsDisplay()
        }
    }
    
    var outIntervalTrackColor: UIColor {
        get {
            trackTintColor
        }
        set {
            trackTintColor = newValue
            trackLayer.setNeedsDisplay()
        }
    }
    
    var roundness: CGFloat {
        get {
            curvaceousness
        }
        set {
            curvaceousness = newValue
        }
    }
    
    func setValue(lowerValue: Float, upperValue: Float, animate: Bool) {
        self.lowerValue = lowerValue
        self.upperValue = upperValue
        
        if animate {
            UIView.animate(withDuration: 0.3) {
                self.updateLayerFrames()
            }
        } else {
            updateLayerFrames()
        }
    }
}

extension RangeSlider {
    
    private func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        if lowerThumb.frame.contains(previousLocation) {
            lowerThumb.highlight = true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlight = true
        }
        
        return lowerThumb.highlight || upperThumbLayer.highlight
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = Double((maximumValue - minimumValue)) * deltaLocation / Double(bounds.width - thumbWidth)
        
        previousLocation = location
        
        // 2. Update the values
        if lowerThumb.highlight {
            lowerValue += Float(deltaValue)
            lowerValue = Float(boundValue(value: Double(lowerValue), toLowerValue: Double(minimumValue), upperValue: Double(upperValue)))
        } else if upperThumbLayer.highlight {
            upperValue += Float(deltaValue)
            upperValue = Float(boundValue(value: Double(upperValue), toLowerValue: Double(lowerValue), upperValue: Double(maximumValue)))
        }
        
        sendActions(for: .valueChanged)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumb.highlight = false
        upperThumbLayer.highlight = false
    }
}


