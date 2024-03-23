//
//  RangeSliderThumb.swift
//  DoubleSidedSlider
//
//  Created by Alex Nasulloev on 22/03/24.
//

import Foundation
import UIKit

class RangeSliderThumb: UIImageView {
    
    var highlight: Bool = false {
        didSet {
            if highlight {
                setImage(activeImage)
            } else {
                setImage(inactiveImage)
            }
        }
    }
    
    var rangeSlider: RangeSliderProperties?
    
    var activeImage: UIImage? = nil
    var inactiveImage: UIImage? = nil
    
    init() {
        super.init(frame: .zero)
        contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ image: UIImage?) {
        self.image = image ?? UIImage(systemName: "circle.fill")?.withTintColor(rangeSlider?.thumbTintColor ?? UIColor.systemBlue, renderingMode: .automatic)
    }
}
