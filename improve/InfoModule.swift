//
//  InfoModule.swift
//  improve
//
//  Created by Denis Bezrukov on 01.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import Swinject

class InfoModule {
    var view: InfoView!
    
    class func initializer(WithItemObject itemObject: ItemModel) -> InfoModule {
        let assembler = try! Assembler(assemblies: [
            InfoModuleAssembly(WithItemObject: itemObject)
            ])
        let module = assembler.resolver.resolve(InfoModule.self)!
        return module
    }
    
}
