//
// Created by Denis Bezrukov on 20.08.16.
// Copyright (c) 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import Swinject

class SelectModule {
    var view: SelectView!

    class func initializer() -> SelectModule {
        let assembler = try! Assembler(assemblies: [
            SelectModuleAssembly()
            ])
        let module = assembler.resolver.resolve(SelectModule.self)!
//        let presenter = module.view.output as! SelectPresenter
//        presenter.module = input
        return module
    }
    
}
