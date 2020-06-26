//
//  ViewController.swift
//  HeaderStickyTab
//
//  Created by nico on 26.06.20.
//  Copyright © 2020 nico. All rights reserved.
//

import UIKit

class HeaderView: UIView, ScrollResponsableView {
    func didScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Main"
        
        
    }

    @IBAction func didTapOpen(_ sender: Any) {
        let childVC = HeaderStickyTabViewController()
        childVC.title = "Child"
        let headerView = HeaderView()
        childVC.headerView = headerView
        
        self.navigationController?.pushViewController(childVC, animated: true)
    }
    
}

