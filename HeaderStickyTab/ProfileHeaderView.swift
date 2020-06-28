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
}
