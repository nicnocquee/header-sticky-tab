//
//  ViewController.swift
//  HeaderStickyTab
//
//  Created by nico on 26.06.20.
//  Copyright © 2020 nico. All rights reserved.
//

import UIKit

class HeaderView: UIView {
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
        
        childVC.headerView = HeaderView()
        childVC.viewControllers = [
            FirstTabViewController(style: .plain),
            SecondTabViewController(style: .plain)
        ]
        
        self.navigationController?.pushViewController(childVC, animated: true)
    }
    
}

class FirstTabViewController: UITableViewController, HeaderStickyTabChildViewController {
    var scrollView: UIScrollView {
        return self.tableView
    }
    var tabTitle: String = "First"
    
    lazy var data: [String] = {
        var array: [String] = []
        for i in 0..<100 {
            array.append("Row \(i)")
        }
        
        return array
    }()
    
    override func viewDidLoad() {
        self.tableView.backgroundColor = .cyan
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.insetsContentViewsToSafeArea = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}

class SubtitleCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SecondTabViewController: UITableViewController, HeaderStickyTabChildViewController {
    var scrollView: UIScrollView {
        return self.tableView
    }
    var tabTitle: String = "Second"
    
    lazy var data: [(String, String)] = {
        var array: [(String, String)] = []
        for i in 0..<100 {
            array.append(("Hello Title \(i)", "This is detail \(i)"))
        }
        
        return array
    }()
    
    override func viewDidLoad() {
        self.tableView.backgroundColor = .green
        self.tableView.register(SubtitleCell.self, forCellReuseIdentifier: "cell")
        self.tableView.insetsContentViewsToSafeArea = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row].0
        cell.detailTextLabel?.text = data[indexPath.row].1
        return cell
    }
}
