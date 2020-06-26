//
//  HeaderStickyTabViewController.swift
//  HeaderStickyTab
//
//  Created by nico on 26.06.20.
//  Copyright © 2020 nico. All rights reserved.
//

import UIKit

protocol ScrollResponsableView: UIView {
    func didScroll (scrollView: UIScrollView)
}

protocol StickyTabResponsableView: ScrollResponsableView {
    var titles: [String] { get set }
    func didChangeTab(to index: Int)
}

protocol HeaderStickyTabChildViewController: UIViewController {
    var scrollView: UIScrollView { get }
    var tabTitle: String { get }
}

class HeaderStickyTabViewController: UIViewController {
    
    var headerView: ScrollResponsableView = EmptyHeaderView()
    var tabView: StickyTabResponsableView = PlainTabView()
    var viewControllers: [HeaderStickyTabChildViewController] = [EmptyChildViewController(style: .plain)]
    
    private var horizontalScrollView = UIScrollView()
    
    override func loadView() {
        super.loadView()
        
        horizontalScrollView.isDirectionalLockEnabled = true
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        horizontalScrollView.backgroundColor = .yellow
        horizontalScrollView.isPagingEnabled = true
        self.view.addSubview(horizontalScrollView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(headerView)
        
        tabView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tabView)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            
            tabView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tabView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            horizontalScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            horizontalScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            horizontalScrollView.topAnchor.constraint(equalTo: tabView.bottomAnchor),
            horizontalScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabView.titles = ["First tab", "Second tab"]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class EmptyHeaderView: UIView, ScrollResponsableView {
    func didScroll(scrollView: UIScrollView) {}
}

class PlainTabView: UIView, StickyTabResponsableView {
    var titles: [String] = [""] {
        didSet {
            contentView.removeAllSegments()
            titles.enumerated().forEach { (index, title) in
                contentView.insertSegment(withTitle: title, at: index, animated: false)
            }
            contentView.selectedSegmentIndex = 0
        }
    }
    func didChangeTab(to index: Int) {}
    func didScroll(scrollView: UIScrollView) {}
    
    lazy var contentView: UISegmentedControl = {
        let segmented = UISegmentedControl(items: self.titles)
        segmented.translatesAutoresizingMaskIntoConstraints = false
        
        return segmented
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .red
        addSubview(contentView)
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    override class var requiresConstraintBasedLayout: Bool {
      return true
    }
}


class EmptyChildViewController: UITableViewController, HeaderStickyTabChildViewController {
    var scrollView: UIScrollView {
        return self.tableView
    }
    var tabTitle: String = "First"
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
