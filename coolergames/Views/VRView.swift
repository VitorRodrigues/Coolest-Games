//
//  VRView.swift
//
//  Created by Vitor Rodrigues on 8/21/17.
//  Copyright © 2017 Vitor Rodrigues. All rights reserved.
//

import UIKit

@IBDesignable
class VRView: UIView {
    @IBInspectable
    var cornerRadius: Int = 0 {
        didSet {
            self.layer.cornerRadius = CGFloat(self.cornerRadius)
            self.layer.masksToBounds = self.cornerRadius > 0
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? = nil {
        didSet {
            self.layer.borderColor = self.borderColor?.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
            setNeedsDisplay()
        }
    }
}

@IBDesignable
class VRGradientView: VRView {
    
    private let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var gradientStartColor: UIColor = .clear {
        didSet{
            updateGradient()
        }
    }
    
    @IBInspectable
    var gradientEndColor: UIColor = .clear {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable
    var horizontal: Bool = false {
        didSet {
            updateGradient()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
    
    private func updateGradient() {
        gradientLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        gradientLayer.locations = [0,1].map({ NSNumber(value: $0) })
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
}
