//
//  HeaderStickyTabTests.swift
//  HeaderStickyTabTests
//
//  Created by nico on 26.06.20.
//  Copyright © 2020 nico. All rights reserved.
//

import XCTest
@testable import HeaderStickyTab

class HeaderStickyTabTests: XCTestCase {

    var profileVC: ProfileViewController!
    var window: UIWindow!
    override func setUpWithError() throws {
        profileVC = ProfileViewController.create()
        window = UIApplication.shared.windows.first!
        window.rootViewController = profileVC
        
        XCTAssertNotNil(profileVC.view)
        profileVC.view.setNeedsLayout()
        profileVC.view.layoutIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testChildViewControllers() throws {
        XCTAssertTrue(profileVC.viewControllers.count == 2)
        XCTAssertEqual(profileVC.viewControllers[1].scrollView.frame.origin.x, window.frame.size.width)
    }
    
    func testTabView() throws {
        XCTAssertTrue((profileVC.tabView as! PlainTabView).titles.count == 2)
        XCTAssertTrue((profileVC.tabView as! PlainTabView).contentView.numberOfSegments == 2)
    }
    
    func testStickyTabViewDelegate() throws {
        var scrollView: UIScrollView!
        for subview in profileVC.view.subviews {
            if subview.isKind(of: UIScrollView.self) {
                scrollView = (subview as! UIScrollView)
            }
        }
        let expectation = XCTestExpectation(description: "Change Tab")
        profileVC.didSelectTab(at: 1)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            XCTAssertEqual(scrollView.contentOffset.x, self.window.frame.size.width)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
}
