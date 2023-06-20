//
//  AppRootViewController.swift
//  PyonsnalTest
//
//  Created by 김인호 on 2023/06/04.
//

import ModernRIBs
import UIKit

protocol AppRootPresentableListener: AnyObject {
}

final class RootTabBarController: UITabBarController, AppRootViewControllable, AppRootPresentable {
    weak var listener: AppRootPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupTabBar()
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupTabBar()
    }
    
    func setupTabBar() {
//        var tabFrame = tabBar.frame
//        let tabBarHeight: CGFloat = .init(86)
//        
//        tabFrame.size.height = tabBarHeight
//        tabFrame.origin.y = view.frame.size.height - tabBarHeight
//        tabBar.frame = tabFrame
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 16
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        tabBar.layer.applyShadow()

        view.layoutIfNeeded()
    }
    
    func setViewControllers(_ viewControllers: [ViewControllable]) {
        super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
    }
}
