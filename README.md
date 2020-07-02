# HeaderStickyTabViewController

## About

A container view controller that displays children view controllers in tabs like the profile screen on Twitter or Instagram without any dependencies. When the user scrolls the scroll view of the child view controller, the tab/segment control stick at the top.

## Features

- Custom header view
- Custom tab view

## Installation

### Manual

Add the `HeaderStickyTabViewController.swift` file from `Sources/HeaderStickyTabViewController` directory to your project.

### Swift Package Manager

Add this package in Xcode: `https://github.com/nicnocquee/header-sticky-tab`

### Cocoapods

Coming soon.

## Usage

- Create a view controller that extends `HeaderStickyTabViewController`
- Assign a view to `headerView` property.
- Assign the children view controllers to `viewControllers` property.
- Override `childDidScroll` function if needed.
- Override `didChangePage` method if needed.

```swift
import HeaderStickyTabViewController

class ProfileViewController: HeaderStickyTabViewController {

    static func create() -> ProfileViewController {
        let vc = ProfileViewController()
        vc.title = "Child"

        vc.headerView = ProfileHeaderView()
        vc.viewControllers = [
            FirstTabViewController(style: .plain),
            SecondTabViewController(style: .plain)
        ]

        return vc
    }
}
```

Checkout `Example/HeaderStickyTab/ProfileViewController.swift` in this repository for example.

## Example

Open `Example/HeaderStickyTab.xcworkspace`. Run the sample app in simulator. The example shows how to blur the header image when user pull down the scroll view.

## License

MIT
