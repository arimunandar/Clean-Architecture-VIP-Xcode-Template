//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ Stockbit - ARI MUNANDAR. All rights reserved.

import Foundation
import AppsRouter
import Swinject

public class ___VARIABLE_productName:identifier___Routers: IAppProductRouter {
    let router: IAppRouter

    let modules: [String: (IAppRouter) -> IAppModule] = [
        // Register all module here...
    ]

    public init(router: IAppRouter) {
        self.router = router
    }

    public func getModule(module: AppModule, parameters: IAppParameter?) -> UIViewController? {
        if let moduleConstructor = modules[module.routePath] {
            let module = moduleConstructor(router)
            return module.createView(parameters: parameters)
        }
        return nil
    }

    public func presentModule(module: AppModule, parameters: IAppParameter?) {
        if let moduleConstructor = modules[module.routePath] {
            let module = moduleConstructor(router)
            module.presentView(parameters: parameters)
        }
    }

    open class func getAssemblies() -> [Assembly] {
        return [
            // Register all Assembly here...
        ]
    }
}
