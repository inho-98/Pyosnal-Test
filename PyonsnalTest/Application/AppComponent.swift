//
//  AppComponent.swift
//  PyonsnalTest
//
//  Created by 김인호 on 2023/06/04.
//

import ModernRIBs

final class AppComponent: Component<EmptyDependency>, AppRootDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}
