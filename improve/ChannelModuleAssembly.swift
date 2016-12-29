//
//  ChannelModuleAssembly.swift
//  improve
//
//  Created by Denis Bezrukov on 01.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import Swinject

class ChannelModuleAssembly:AssemblyType {
    
    var channelObject:ChannelModel?
    var extended: Bool = false
    
    convenience init(WithChannelObject channelObject:ChannelModel, AndExtended extended:Bool) {
        self.init()
        self.channelObject = channelObject
        self.extended = extended
    }
    
    func assemble(container: Container) {
        container.register(ChannelModule.self) { r in
            let сhannelModule = ChannelModule()
            
            guard let view:UIViewController = {
                if self.extended {
                    return r.resolve(ChannelView.self)
                } else {
                    return r.resolve(ChannelCollectionView.self)
                }
            }() else {
                debugPrint("ChannelModule assembly error")
                return сhannelModule
            }
            сhannelModule.view = view
            return сhannelModule
        }
        
        container.register(ChannelCollectionView.self) { _ in
            ChannelCollectionView.init() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolver, channelView) in
                guard let output = resolver.resolve(ChannelPresenter.self) else {
                    debugPrint("ChannelCollectionView assembly error")
                    return
                }
                channelView.output = output
        }
        
        container.register(ChannelView.self) { _ in  ChannelView.init(Extended: self.extended) }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolver, channelView) in
                guard let output = resolver.resolve(ChannelPresenter.self) else {
                    debugPrint("ChannelView assembly error")
                    return
                }
                channelView.output = output
        }
        
        container.register(ChannelPresenter.self) { _ in ChannelPresenter() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { resolver, channelPresenter in
                guard let view: ChannelViewInput = {
                                if self.extended { return resolver.resolve(ChannelView.self) }
                                else {             return resolver.resolve(ChannelCollectionView.self) } }(),
                      let interactor = resolver.resolve(ChannelInteractor.self),
                      let router     = resolver.resolve(ChannelRouter.self) else {
                        debugPrint("ChannelPresenter assembly error")
                        return
                }
                channelPresenter.view = view
                channelPresenter.interactor = interactor
                channelPresenter.router = router
        }
        container.register(ChannelInteractor.self) { _ in ChannelInteractor() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolver, channelInteractor) in
                guard let output = resolver.resolve(ChannelPresenter.self),
                      let dataService = resolver.resolve(DataService.self) else {
                        debugPrint("ChannelInteractor assembly error")
                        return
                }
                channelInteractor.dataService = dataService
                channelInteractor.output = output
        }
        
        container.register(DataService.self) { _ in
            let mappings:YapDatabaseViewMappings = {
                var groups:[String] = []
                DatabaseManager.connection.readWithBlock { (transaction) in
                    if let ext = transaction.ext(DatabaseManager.extensionTitleItemsExtended) as? YapDatabaseViewTransaction {
                        groups += ext.allGroups().sort({ (first, second) -> Bool in
                            let firstDate = first.componentsSeparatedByString("+").last!
                            let secondDate = second.componentsSeparatedByString("+").last!
                            return Int.init(firstDate)! > Int.init(secondDate)!
                        }).filter({ [unowned self] group -> Bool in
                            let collection = (group as NSString).substringWithRange(NSMakeRange(0, group.characters.count - 7))
                            return collection == self.channelObject!.key
                            })
                    }
                }
                return YapDatabaseViewMappings(
                    groups:groups,
                    view:DatabaseManager.extensionTitleItemsExtended)
            }()
//            let mappings:YapDatabaseViewMappings = YapDatabaseViewMappings(
//                groups:[self.channelObject!.key],
//                view:DatabaseManager.extensionTitleItems)
            for group in mappings.allGroups {
                mappings.setRangeOptions(
                    YapDatabaseViewRangeOptions.fixedRangeWithLength(5, offset:0, from:.Beginning),
                    forGroup:group)
            }
            mappings.setIsDynamicSectionForAllGroups(true)
            return DataService(Mappings:mappings)
            }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolverType, dataService) in
                guard let output = resolverType.resolve(ChannelInteractor.self) else {
                    debugPrint("DataService assembly error")
                    return
                }
                dataService.output = output
        }
        
        container.register(ChannelRouter.self) { _ in ChannelRouter() }
            .inObjectScope(ObjectScope.Container)
            .initCompleted { (resolver, channelRouter) in
                
                guard let view:ChannelViewInput = {
                    if self.extended {
                        return resolver.resolve(ChannelView.self)
                    } else {
                        return resolver.resolve(ChannelCollectionView.self)
                    }
                    }() else {
                        debugPrint("ChannelRouter assembly error")
                        return
                }
                channelRouter.view = view
        }
    }
}
