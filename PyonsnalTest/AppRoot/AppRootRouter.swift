//
//  AppRootRouter.swift
//  PyonsnalTest
//
//  Created by 김인호 on 2023/06/04.
//

import ModernRIBs

protocol AppRootInteractable: Interactable, AppHomeListener, EventHomeListener, ProfileHomeListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
    private let appHome: AppHomeBuildable
    private let eventHome: EventHomeBuildable
    private let profileHome: ProfileHomeBuildable
    
    private var appHomeRouting: ViewableRouting?
    private var eventHomeRouting: ViewableRouting?
    private var profileHomeRouting: ViewableRouting?

    init(
      interactor: AppRootInteractable,
      viewController: AppRootViewControllable,
      appHome: AppHomeBuildable,
      eventHome: EventHomeBuildable,
      profileHome: ProfileHomeBuildable
    ) {
      self.appHome = appHome
      self.eventHome = eventHome
      self.profileHome = profileHome
      
      super.init(interactor: interactor, viewController: viewController)
      interactor.router = self
    }
    
    func attachTabs() {
        let appHomeBuilder = appHome.build(withListener: interactor)
        let eventHomeBuilder = eventHome.build(withListener: interactor)
        let profileHomeBuilder = profileHome.build(withListener: interactor)
        
        attachChild(appHomeBuilder)
        attachChild(eventHomeBuilder)
        attachChild(profileHomeBuilder)
        
        let viewControllers: [ViewControllable] = [
            NavigationControllerable(root: appHomeBuilder.viewControllable),
            NavigationControllerable(root: eventHomeBuilder.viewControllable),
            NavigationControllerable(root: profileHomeBuilder.viewControllable)
        ]
        
        viewController.setViewControllers(viewControllers)
    }
}
