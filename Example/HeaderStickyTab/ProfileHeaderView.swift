//
//  HeaderView.swift
//  HeaderStickyTab
//
//  Created by nico on 28.06.20.
//  Copyright © 2020 nico. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var avatarContainerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    private func setupView() {
        self.avatarImageView.layer.cornerRadius = self.avatarContainerView.frame.width / 2.0
        self.avatarContainerView.layer.cornerRadius = self.avatarImageView.layer.cornerRadius
        self.avatarContainerView.layer.shadowRadius = 5
        self.avatarContainerView.layer.shadowOffset = .zero
        self.avatarContainerView.layer.shadowOpacity = 1
        
        self.blurView.removeFromSuperview()
        self.headerImageView.addSubview(self.blurView)
        self.blurView.alpha = 0
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: String(describing: ProfileHeaderView.self), bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)

        // custom initialization logic
        setupView()
    }
    
    func didScroll(by distance: Float) {
        if distance < 0 {
            let scaleTransformValue = interpolate(range: Float(0)..<100, domain: 1..<2, value: Float(abs(distance)))
            self.headerImageView.transform = CGAffineTransform(scaleX: CGFloat(scaleTransformValue), y: CGFloat(scaleTransformValue))
            self.blurView.transform = CGAffineTransform(scaleX: CGFloat(scaleTransformValue), y: CGFloat(scaleTransformValue))
            
            self.avatarContainerView.transform = CGAffineTransform(translationX: 0, y: 0)
            
            let blurTransformValue = interpolate(range: 1..<1.5, domain: 0..<1, value: scaleTransformValue)
            self.blurView.alpha = CGFloat(blurTransformValue)
        } else {
            let transformValue2 = interpolate(range: Float(0)..<Float(self.frame.size.height), domain: Float(0)..<Float(self.frame.size.height), value: Float(abs(distance)))
            self.avatarContainerView.transform = CGAffineTransform(translationX: 0, y: CGFloat(-transformValue2))
        }
    }
}

func interpolate (range: Range<Float>, domain: Range<Float>, value: Float) -> Float {
    if value < range.lowerBound {
        return domain.lowerBound
    }
    if value > range.upperBound {
        return domain.upperBound
    }
    return domain.lowerBound + (domain.upperBound - domain.lowerBound) * (value - range.lowerBound) / (range.upperBound - range.lowerBound)
}
