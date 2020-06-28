//
//  ViewController.swift
//  HeaderStickyTab
//
//  Created by nico on 26.06.20.
//  Copyright © 2020 nico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Main"
        
        
    }

    @IBAction func didTapOpen(_ sender: Any) { 
        self.navigationController?.pushViewController(ProfileViewController.create(), animated: true)
    }
    
}
