//
//  HeaderStickyTabViewController.swift
//  HeaderStickyTab
//
//  Created by nico on 26.06.20.
//  Copyright © 2020 nico. All rights reserved.
//

import UIKit

public protocol StickyTabViewDelegate: AnyObject {
    func  didSelectTab(at index: Int)
}

public protocol StickyTabView: UIView {
    var titles: [String] { get set }
    var indexSelectionDelegate: StickyTabViewDelegate? { get set }
    func didChangeTab(to index: Int)
}

public protocol HeaderStickyTabChildViewController: UIViewController {
    var scrollView: UIScrollView { get }
    var tabTitle: String { get }
}

open class HeaderStickyTabViewController: UIViewController {
    public var headerView: UIView = EmptyHeaderView()
    public var tabView: StickyTabView = PlainTabView() {
        didSet {
            tabView.indexSelectionDelegate = self
        }
    }
    public var viewControllers: [HeaderStickyTabChildViewController] = [EmptyChildViewController(style: .plain)]
    
    private var headerViewTopAnchorConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var verticalScrollTopInset: CGFloat = 0
    private var horizontalScrollView = UIScrollView()
    private var contentOffsetObservers: [NSKeyValueObservation] = []
    
    public override func loadView() {
        super.loadView()
        
        horizontalScrollView.isDirectionalLockEnabled = true
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        horizontalScrollView.contentInsetAdjustmentBehavior = .never
        horizontalScrollView.backgroundColor = .yellow
        horizontalScrollView.isPagingEnabled = true
        self.view.addSubview(horizontalScrollView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerViewTopAnchorConstraint = headerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0) // the constraint of the top of header view. will be set according to table view offset
        headerViewTopAnchorConstraint.priority = UILayoutPriority(rawValue: 999) // lower down the priority to avoid conflict with [Constraint1] (see below)
        self.view.addSubview(headerView)
        
        tabView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tabView)
                
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor), // pin left to superview
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor), // pin right to superview
            headerViewTopAnchorConstraint, // constraint that will change along with scroll view
            headerView.topAnchor.constraint(lessThanOrEqualTo: self.view.topAnchor), // pin the header on the top when scroll view is pulled down
            headerView.bottomAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor), // [Constraint1]: pin the tab at the top when user scrolls up
            
            tabView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor), // pin tab to left
            tabView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor), // pin tab to right
            tabView.topAnchor.constraint(equalTo: headerView.bottomAnchor), // pin tab to bottom of header view
            
            // pin all sides of horizontal scroll view to the superview
            horizontalScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            horizontalScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            horizontalScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            horizontalScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        horizontalScrollView.delegate = self
        tabView.indexSelectionDelegate = self
        
        addChildViewControllers(self.viewControllers)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // observe the content offset of the children's scroll views
        viewControllers.enumerated().forEach { (index, vc) in
            contentOffsetObservers.append(vc.scrollView.observe(\UIScrollView.contentOffset, options: .new) { (scrollView, change) in
                self.childDidScroll(child: vc, childIndex: index, yOffset: change.newValue!.y)
            })
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentOffsetObservers.forEach { (observer) in
            observer.invalidate()
        }
        
        contentOffsetObservers.removeAll()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if verticalScrollTopInset == 0 {
            verticalScrollTopInset = tabView.frame.maxY
            
            viewControllers.forEach { (vc) in
                vc.scrollView.contentInsetAdjustmentBehavior = .never
                vc.scrollView.contentInset.top = verticalScrollTopInset
                // vc.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
                vc.scrollView.verticalScrollIndicatorInsets.top = verticalScrollTopInset
                vc.scrollView.setContentOffset(CGPoint(x: 0, y: -verticalScrollTopInset), animated: false)
            }
        }
        
    }

    func addChildViewControllers(_ childVCs: [HeaderStickyTabChildViewController]) {
        // set the tabs titles
        self.tabView.titles = childVCs.map { childVc in
            return childVc.tabTitle
        }
        
        // set constraints for each child view controller
        let constraints = childVCs.enumerated().flatMap { (index, childVC) -> [NSLayoutConstraint] in
            var childConstraints: [NSLayoutConstraint] = []

            childVC.scrollView.translatesAutoresizingMaskIntoConstraints = false
            horizontalScrollView.addSubview(childVC.scrollView)
            
            childConstraints.append(contentsOf: [
                childVC.scrollView.topAnchor.constraint(equalTo: horizontalScrollView.topAnchor, constant: 0), // pin the child's scroll view to the top of horizontal scroll view
                childVC.scrollView.heightAnchor.constraint(equalTo: horizontalScrollView.heightAnchor), // set the child's scroll view's height to the height of horizontal scroll view
                childVC.scrollView.widthAnchor.constraint(equalTo: horizontalScrollView.widthAnchor) // set the child's scroll view's width to the width of horizontal scroll view
            ])
            
            if (index == 0) {
                childConstraints.append(childVC.scrollView.leadingAnchor.constraint(equalTo: horizontalScrollView.leadingAnchor, constant: 0)) // pin the first child's scroll view to the left of horizontal scroll view
            } else {
                childConstraints.append(childVC.scrollView.leadingAnchor.constraint(equalTo: childVCs[index - 1].scrollView.trailingAnchor, constant: 0)) // pin the other child's scroll view's left to the right of previous child's scroll view
            }
            if (index == childVCs.count - 1) {
                childConstraints.append(childVC.scrollView.trailingAnchor.constraint(equalTo: horizontalScrollView.trailingAnchor)) // pin the last child's scroll view to the right of horizontal scroll view
            }
            
            self.addChild(childVC)
            childVC.didMove(toParent: self)
                        
            return childConstraints
        }
                
        if constraints.count > 0 {
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    /**
        Override this function if you want to do something after page changes. DO NOT FORGET TO CALL super.didChangePage
     */
    open func didChangePage(_ page: Int) {
        horizontalScrollView.setContentOffset(CGPoint(x: CGFloat(page) * horizontalScrollView.frame.width, y: 0), animated: true) // scroll the horizontal view to the selected page
         self.tabView.didChangeTab(to: page) // notify the tab view that page changes because user scroll to left or right
    }
    
    /**
     Override this function if you want to do something when the child view controller scrolls. DO NOT FORGET TO CALL super.childDidScroll
     */
    open func childDidScroll(child: HeaderStickyTabChildViewController, childIndex: Int, yOffset: CGFloat) {
        // push the header around based on the content offset of the child's scroll view
        self.headerViewTopAnchorConstraint.constant = -(yOffset + self.verticalScrollTopInset)
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension HeaderStickyTabViewController: StickyTabViewDelegate {
    public func didSelectTab(at index: Int) {
        self.didChangePage(index)
    }
}

extension HeaderStickyTabViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = getPage(of: scrollView)
        self.didChangePage(page)
        
    }
    
    func getPage(of scrollView: UIScrollView) -> Int {
        let page = ceil(scrollView.contentOffset.x / scrollView.frame.width)
        
        return Int(page)
    }
}

// sample header view
class EmptyHeaderView: UIView {
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

/**
 Simple tab view
 */
class PlainTabView: UIView, StickyTabView {
    weak var indexSelectionDelegate: StickyTabViewDelegate?
    
    var titles: [String] = [""] {
        didSet {
            contentView.removeAllSegments()
            titles.enumerated().forEach { (index, title) in
                contentView.insertSegment(withTitle: title, at: index, animated: false)
            }
            contentView.selectedSegmentIndex = 0
        }
    }
    func didChangeTab(to index: Int) {
        self.contentView.selectedSegmentIndex = index
    }
    func didScroll(scrollView: UIScrollView) {}
    
    lazy var contentView: UISegmentedControl = {
        let segmented = UISegmentedControl(items: self.titles)
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.addTarget(self, action: #selector(didChangeSegmentedController(sender:)), for: .valueChanged)
        
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
    
    @objc func didChangeSegmentedController (sender: UISegmentedControl) {
        self.indexSelectionDelegate?.didSelectTab(at: sender.selectedSegmentIndex)
    }
    
    override class var requiresConstraintBasedLayout: Bool {
      return true
    }
}

/**
 Simple child view controller
 */
class EmptyChildViewController: UITableViewController, HeaderStickyTabChildViewController {
    var scrollView: UIScrollView {
        return self.tableView
    }
    var tabTitle: String = "First"
    
    var data: [String] =  []
    
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
