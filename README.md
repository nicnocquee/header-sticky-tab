# HeaderStickyTabViewController

## About

A container view controller that displays children view controllers in tabs like the profile screen on Twitter or Instagram.

## Usage

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

Checkout ProfileViewController.swift in this repository for example.

## License

MIT
