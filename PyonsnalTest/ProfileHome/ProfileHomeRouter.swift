//
//  ProfileHomeRouter.swift
//  PyonsnalTest
//
//  Created by 김인호 on 2023/06/04.
//

import ModernRIBs

protocol ProfileHomeInteractable: Interactable {
    var router: ProfileHomeRouting? { get set }
    var listener: ProfileHomeListener? { get set }
}

protocol ProfileHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileHomeRouter: ViewableRouter<ProfileHomeInteractable, ProfileHomeViewControllable>, ProfileHomeRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProfileHomeInteractable, viewController: ProfileHomeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
