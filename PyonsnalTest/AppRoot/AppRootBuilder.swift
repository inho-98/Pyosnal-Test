//
//  AppRootBuilder.swift
//  PyonsnalTest
//
//  Created by 김인호 on 2023/06/04.
//

import ModernRIBs

protocol AppRootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AppRootComponent:
    Component<AppRootDependency>,
    AppHomeDependency,
    EventHomeDependency,
    ProfileHomeDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AppRootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {

    override init(dependency: AppRootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let component: AppRootComponent = .init(dependency: dependency)
        let tabBar: RootTabBarController = .init()
        let interactor: AppRootInteractor = .init(presenter: tabBar)
        
        let appHomeBuilder: AppHomeBuilder = .init(dependency: component)
        let eventHomeBuilder: EventHomeBuilder = .init(dependency: component)
        let profileHomeBuilder: ProfileHomeBuilder = .init(dependency: component)
        
        let router: AppRootRouter = .init(
            interactor: interactor,
            viewController: tabBar,
            appHome: appHomeBuilder,
            eventHome: eventHomeBuilder,
            profileHome: profileHomeBuilder
        )

        return router
    }
}
