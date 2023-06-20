//
//  ProfileHomeViewController.swift
//  PyonsnalTest
//
//  Created by 김인호 on 2023/06/04.
//

import ModernRIBs
import UIKit

protocol ProfileHomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ProfileHomeViewController: UIViewController, ProfileHomePresentable, ProfileHomeViewControllable {

    weak var listener: ProfileHomePresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        tabBarItem = UITabBarItem(
            title: "MY",
            image: .init(named: "마이페이지"),
            selectedImage: .init(named: "마이페이지.fill")
        )
        view.backgroundColor = .white
    }
}
