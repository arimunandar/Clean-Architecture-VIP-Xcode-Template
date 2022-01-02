//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ Stockbit - ARI MUNANDAR. All rights reserved.

import UIKit
import AppsRouter

// MARK: - ___VARIABLE_productName:identifier___ViewControllerDelegate

protocol ___VARIABLE_productName:identifier___ViewControllerDelegate: AnyObject {
    // do someting...
}

// MARK: - I___VARIABLE_productName:identifier___Wireframe

protocol I___VARIABLE_productName:identifier___Wireframe {
    func presentView()
}

// MARK: - ___VARIABLE_productName:identifier___Wireframe

class ___VARIABLE_productName:identifier___Wireframe: I___VARIABLE_productName:identifier___Wireframe {
    var appRouter: IAppRouter
    weak var delegate: ___VARIABLE_productName:identifier___ViewControllerDelegate?

    init(appRouter: IAppRouter, delegate: ___VARIABLE_productName:identifier___ViewControllerDelegate?) {
        self.appRouter = appRouter
        self.delegate = delegate
    }

    func presentView() {
        let view = appRouter.resolver.resolve(___VARIABLE_productName:identifier___ViewController.self, argument: appRouter)!
        appRouter.presentView(view: view)
    }
}
