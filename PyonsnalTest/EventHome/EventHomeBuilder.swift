//
//  EventHomeBuilder.swift
//  PyonsnalTest
//
//  Created by 김인호 on 2023/06/04.
//

import ModernRIBs

protocol EventHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class EventHomeComponent: Component<EventHomeDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol EventHomeBuildable: Buildable {
    func build(withListener listener: EventHomeListener) -> EventHomeRouting
}

final class EventHomeBuilder: Builder<EventHomeDependency>, EventHomeBuildable {

    override init(dependency: EventHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EventHomeListener) -> EventHomeRouting {
        let component = EventHomeComponent(dependency: dependency)
        let viewController = EventHomeViewController()
        let interactor = EventHomeInteractor(presenter: viewController)
        interactor.listener = listener
        return EventHomeRouter(interactor: interactor, viewController: viewController)
    }
}
