//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ Stockbit - ARI MUNANDAR. All rights reserved.

import UIKit
import AppsRouter

// MARK: - ___VARIABLE_productName:identifier___Module

public class ___VARIABLE_productName:identifier___Module: IAppModule {
    let appRouter: IAppRouter

    public init(_ appRouter: IAppRouter) {
        self.appRouter = appRouter
    }

    public func presentView(parameters: IAppParameter?) {
        let delegate = appRouter.resolver.resolve(___VARIABLE_productName:identifier___ViewController.self, argument: appRouter)!
        let wireframe = appRouter.resolver.resolve(I___VARIABLE_productName:identifier___Wireframe.self, arguments: appRouter, delegate as ___VARIABLE_productName:identifier___ViewControllerDelegate)!
        wireframe.presentView()
    }

    public func createView(parameters: IAppParameter?) -> UIViewController {
        let view = appRouter.resolver.resolve(___VARIABLE_productName:identifier___ViewController.self, argument: appRouter)!
        return view
    }
}
