//
//  DCLoadingView.swift
//  Dr Consulta
//
//  Created by Vitor Rodrigues on 8/31/17.
//  Copyright © 2017 Vitor Rodrigues. All rights reserved.
//

import UIKit

class VRLoadingView: VRView {
    
    @IBOutlet private weak var loading: UIActivityIndicatorView!
    @IBOutlet private weak var label: UILabel!
    weak var widthConstraint: NSLayoutConstraint?
    
    var text: String? {
        didSet {
            label.text = text
            setNeedsLayout()
        }
    }
    
    func startAnimating() {
        loading.startAnimating()
    }
    
    func stopAnimating() {
        loading.stopAnimating()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.text = "Loading"
        label.numberOfLines = 0
        cornerRadius = 5
        self.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        let width = self.widthAnchor.constraint(equalToConstant: 80)
        width.priority = UILayoutPriority.fittingSizeLevel
        width.isActive = true
    }
    
    static func fromXib() -> VRLoadingView {
        let nib = UINib(nibName: "VRLoadingView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! VRLoadingView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true //Keep aspect ratio
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        return view
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        self.center = view.center
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        show()
        layoutIfNeeded()
    }
    
    func show() {
        self.isHidden = false
        superview?.bringSubview(toFront: self)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (finished) in
            if finished {
                self.alpha = 0
                self.isHidden = true
                self.removeFromSuperview()
            }
        }
    }
}
