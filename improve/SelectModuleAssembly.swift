//
//  SelectModuleAssembly.swift
//  improve
//
//  Created by Denis Bezrukov on 24.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import Swinject

class SelectModuleAssembly:AssemblyType {
    
    func assemble(container: Container) {
        container.register(SelectModule.self) { r in
            let selectModule = SelectModule()
            guard let view = r.resolve(SelectView.self) else {
                debugPrint("SelectModule assembly error")
                return selectModule
            }
            selectModule.view = view
            return selectModule
        }
        container.register(SelectView.self) { _ in  SelectView() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolverType, selectView) in
                guard let output = resolverType.resolve(SelectPresenter.self) else {
                    debugPrint("SelectView assembly error")
                    return
                }
                selectView.output = output
        }
        
        container.register(SelectPresenter.self) { _ in SelectPresenter() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { r, selectPresenter in
                guard let view       = r.resolve(SelectView.self),
                      let interactor = r.resolve(SelectInteractor.self),
                      let router     = r.resolve(SelectRouter.self) else {
                        debugPrint("SelectPresenter assembly error")
                        return
                }
                selectPresenter.view = view
                selectPresenter.interactor = interactor
                selectPresenter.router = router
        }
        container.register(SelectInteractor.self) { _ in SelectInteractor() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolver, selectInteractor) in
                guard let output = resolver.resolve(SelectPresenter.self),
                      let dataService = resolver.resolve(DataService.self),
                      let requestResponseObjectService = resolver.resolve(RequestService<ResponseObject>.self) else {
                        debugPrint("SelectInteractor assembly error")
                        return
                }
                selectInteractor.requestResponseObjectService = requestResponseObjectService
                selectInteractor.dataService = dataService
                selectInteractor.output = output
        }
        container.register(DataService.self) { _ in
                let mappings = YapDatabaseViewMappings(
                    groups:[DatabaseManager.groupTitleChannelDefault, DatabaseManager.groupTitleChannelManual],
                    view:DatabaseManager.extensionTitleChannels)
                mappings.setIsDynamicSectionForAllGroups(true)
                return DataService(Mappings:mappings)
            }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolverType, dataService) in
                guard let output = resolverType.resolve(SelectInteractor.self) else {
                    debugPrint("DataService assembly error")
                    return
                }
                dataService.output = output
        }
        container.register(RequestService<ResponseObject>.self) { _ in RequestService() }
            .inObjectScope(ObjectScope.None)
            .initCompleted { (resolver, requestService) in
                guard let output = resolver.resolve(SelectInteractor.self) else {
                    debugPrint("RequestService<ResponseObject> assembly error")
                    return
                }
                requestService.output = output
                requestService.functionConvertFromData = requestService.convertFromXML
        }

        container.register(SelectRouter.self) { _ in SelectRouter() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolverType, selectRouter) in
                guard let view = resolverType.resolve(SelectView.self) else {
                    debugPrint("SelectRouter assembly error")
                    return
                }
                selectRouter.view = view
        }
    }
}
