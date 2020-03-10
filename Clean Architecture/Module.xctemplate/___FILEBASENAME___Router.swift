//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//  Modify By:  * Ari Munandar
//              * arimunandar.dev@gmail.com
//              * https://github.com/arimunandar
//              * https://www.youtube.com/channel/UC7jr8DR06tcVR0QKKl6cSNA?view_as=subscriber

import UIKit

protocol I___VARIABLE_productName:identifier___Router {
	// do someting...
}

class ___VARIABLE_productName:identifier___Router: I___VARIABLE_productName:identifier___Router {
    var appRouter: IAppRouter

    init(appRouter: IAppRouter) {
        self.appRouter = appRouter
    }

    func presentView(parameters: [String: Any]) {
        appRouter.presentView(
            view: create(parameters: parameters),
            animetedDisplay: true,
            animatedDismiss: true
        )
    }

    func create(parameters: [String: Any]) -> UIViewController {
        let view = ___VARIABLE_productName:identifier___ViewController(nibName: "___VARIABLE_productName:identifier___ViewController", bundle: nil)
        let presenter = ___VARIABLE_productName:identifier___Presenter(view: view)
        let interactor = ___VARIABLE_productName:identifier___Interactor(presenter: presenter)
        view.interactor = interactor
        view.router = self
        interactor.parameters = parameters
        return view
    }
}
