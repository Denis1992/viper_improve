//
//  InfoModuleAssembly.swift
//  improve
//
//  Created by Denis Bezrukov on 01.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import Swinject

class InfoModuleAssembly:AssemblyType {
    
    var itemObject:ItemModel?
    
    convenience init(WithItemObject itemObject:ItemModel) {
        self.init()
        self.itemObject = itemObject
    }
    
    func assemble(container: Container) {
        container.register(InfoModule.self) { r in
            let infoModule = InfoModule()
            guard let view = r.resolve(InfoView.self) else {
                debugPrint("InfoModule assembly error")
                return infoModule
            }
            infoModule.view = view
            return infoModule
        }
        
        container.register(InfoView.self) { _ in  InfoView() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolver, infoView) in
                guard let output = resolver.resolve(InfoPresenter.self) else {
                    debugPrint("InfoView assembly error")
                    return
                }
                infoView.output = output
        }
        container.register(InfoPresenter.self) { _ in InfoPresenter() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { r, infoPresenter in
                guard let view     = r.resolve(InfoView.self),
                    let interactor = r.resolve(InfoInteractor.self),
                    let router     = r.resolve(InfoRouter.self) else {
                        debugPrint("InfoPresenter assembly error")
                        return
                }
                infoPresenter.view = view
                infoPresenter.interactor = interactor
                infoPresenter.router = router
        }
        container.register(InfoInteractor.self) { _ in InfoInteractor() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolver, infoInteractor) in
                guard let output = resolver.resolve(InfoPresenter.self) else {
                        debugPrint("InfoInteractor assembly error")
                        return
                }
                infoInteractor.itemObject = self.itemObject
                infoInteractor.output = output
        }
        container.register(InfoRouter.self) { _ in InfoRouter() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolverType, infoRouter) in
                guard let view = resolverType.resolve(InfoView.self) else {
                    debugPrint("InfoRouter assembly error")
                    return
                }
                infoRouter.view = view
        }
    }
}
