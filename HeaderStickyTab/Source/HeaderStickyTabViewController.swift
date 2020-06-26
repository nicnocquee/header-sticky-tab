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
    
    private var headerViewTopAnchorConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var verticalScrollTopInset: CGFloat = 0
    private var horizontalScrollView = UIScrollView()
    
    override func loadView() {
        super.loadView()
        
        horizontalScrollView.isDirectionalLockEnabled = true
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        horizontalScrollView.contentInsetAdjustmentBehavior = .never
        horizontalScrollView.backgroundColor = .yellow
        horizontalScrollView.isPagingEnabled = true
        self.view.addSubview(horizontalScrollView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerViewTopAnchorConstraint = headerView.topAnchor.constraint(equalTo: self.view.topAnchor)
        headerViewTopAnchorConstraint.priority = UILayoutPriority(rawValue: 999)
        self.view.addSubview(headerView)
        
        tabView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tabView)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerViewTopAnchorConstraint,
            headerView.bottomAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor, constant: self.view.safeAreaInsets.top),
            
            tabView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tabView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            horizontalScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            horizontalScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            horizontalScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            horizontalScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabView.titles = ["First tab", "Second tab"]
        
        addChildViewControllers(self.viewControllers)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        verticalScrollTopInset = tabView.frame.maxY
        
        viewControllers.forEach { (vc) in
            vc.scrollView.contentInsetAdjustmentBehavior = .never
            vc.scrollView.contentInset.top = verticalScrollTopInset
            vc.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
            vc.scrollView.verticalScrollIndicatorInsets.top = verticalScrollTopInset
            vc.scrollView.setContentOffset(CGPoint(x: 0, y: -verticalScrollTopInset), animated: false)
        }
    }

    func addChildViewControllers(_ childVCs: [HeaderStickyTabChildViewController]) {
        let constraints = childVCs.enumerated().flatMap { (index, childVC) -> [NSLayoutConstraint] in
            var childConstraints: [NSLayoutConstraint] = []

            childVC.scrollView.translatesAutoresizingMaskIntoConstraints = false
            horizontalScrollView.addSubview(childVC.scrollView)
            
            childConstraints.append(contentsOf: [
                childVC.scrollView.topAnchor.constraint(equalTo: horizontalScrollView.topAnchor, constant: 0),
                childVC.scrollView.heightAnchor.constraint(equalTo: horizontalScrollView.heightAnchor),
                childVC.scrollView.widthAnchor.constraint(equalTo: horizontalScrollView.widthAnchor)
            ])
            
            if (index == 0) {
                childConstraints.append(childVC.scrollView.leadingAnchor.constraint(equalTo: horizontalScrollView.leadingAnchor, constant: 0))
            }
            
            self.addChild(childVC)
            
            childVC.didMove(toParent: self)
                        
            return childConstraints
        }
        
        if constraints.count > 0 {
            NSLayoutConstraint.activate(constraints)
        }
        
    }

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
