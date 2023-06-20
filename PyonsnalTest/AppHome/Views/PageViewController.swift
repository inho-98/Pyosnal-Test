//
//  PageViewController.swift
//  PyonsnalTest
//
//  Created by 김인호 on 2023/06/17.
//

import UIKit

protocol PageViewControllerDelegate: NSObject {
    func didChangePage(_ viewController: ProductsViewController)
}

final class PageViewController: UIPageViewController {
    
    var pageDelegate: PageViewControllerDelegate?
    private var productsViewControllers: [ProductsViewController] = []
    var currentViewController: ProductsViewController? {
        didSet {
            guard let currentViewController else { return }
            
            pageDelegate?.didChangePage(currentViewController)
        }
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation)
        
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<5 {
            let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple]
            let viewController = ProductsViewController()
            viewController.view.backgroundColor = colors[index]
            productsViewControllers.append(viewController)
        }
        
        delegate = self
        dataSource = self
        
        if let firstViewController = productsViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true)
            currentViewController = firstViewController
        }
    }
    
    func changeViewController(
        index: Int,
        direction: UIPageViewController.NavigationDirection,
        animated: Bool
    ) {
        guard let viewControllers else { return }
        
        setViewControllers([viewControllers[index]], direction: direction, animated: animated)
    }
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let productViewController = viewController as? ProductsViewController,
              let index = productsViewControllers.firstIndex(of: productViewController)
        else {
            return nil
        }
        
        if index - 1 < 0 {
            return nil
        }
        
        currentViewController = productsViewControllers[index-1]
        return productsViewControllers[index-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let productViewController = viewController as? ProductsViewController,
              let index = productsViewControllers.firstIndex(of: productViewController)
        else {
            return nil
        }
        
        if index + 1 == productsViewControllers.count {
            return nil
        }
        
        currentViewController = productsViewControllers[index+1]
        return productsViewControllers[index+1]
    }

}

//extension UICollectionView {
//    override open var isScrollEnabled: Bool {
//        didSet {
//            if isScrollEnabled == true {
//                becomeFirstResponder()
//            }
//        }
//    }
//}
