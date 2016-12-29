//
//  RootModuleAssembly.swift
//  improve
//
//  Created by Denis Bezrukov on 24.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import Swinject

class RootModuleAssembly:AssemblyType {
    
    func assemble(container: Container) {
        container.register(RootModule.self) { r in
            let rootModule = RootModule()
            guard let view = r.resolve(RootView.self) else {
//                debugPrint("RootModule assembly error")
                return rootModule
            }
            rootModule.view = view
            return rootModule
        }
        container.register(RootView.self) { _ in RootView.init() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolveType, rootView) in
//                debugPrint("RootView init")
                guard let output = resolveType.resolve(RootPresenter.self) else {
                    debugPrint("RootView assembly error")
                    return
                }
                rootView.backgroundColor = UIColor.redColor()
//                debugPrint("RootView output = \(output)")
                rootView.output = output

        }

        container.register(RootPresenter.self) { _ in RootPresenter() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { r, rootPresenter in
//            debugPrint("RootPresenter init")
            guard let view       = r.resolve(RootView.self),
                  let interactor = r.resolve(RootInteractor.self),
                  let router     = r.resolve(RootRouter.self) else {
                debugPrint("RootPresenter vassembly error")
                return
            }
            rootPresenter.view = view
            rootPresenter.interactor = interactor
            rootPresenter.router = router
        }
        container.register(RootInteractor.self) { _ in RootInteractor() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolveType, rootInteractor) in
//                debugPrint("RootInteractor init")
                guard let output = resolveType.resolve(RootPresenter.self) else {
                    debugPrint("RootPresenter vassembly error")
                    return
                }
                rootInteractor.output = output
        }
        container.register(RootRouter.self) { _ in RootRouter() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolveType, rootRouter) in
//                debugPrint("RootRouter init")
                guard let view = resolveType.resolve(RootView.self) else {
                    debugPrint("RootRouter vassembly error")
                    return
                }
                rootRouter.view = view
        }
    }
}
