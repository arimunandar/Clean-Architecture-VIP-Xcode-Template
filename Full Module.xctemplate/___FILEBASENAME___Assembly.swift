//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ Stockbit - ARI MUNANDAR. All rights reserved.

import UIKit
import Foundation
import Swinject
import AppsRouter

// MARK: - ___VARIABLE_productName:identifier___Assembly

class ___VARIABLE_productName:identifier___Assembly: Assembly {
    func assemble(container: Container) {
        container.register(I___VARIABLE_productName:identifier___Manager.self) {(r) in
            return ___VARIABLE_productName:identifier___Manager()
        }.inObjectScope(.transient)
        
        container.register(I___VARIABLE_productName:identifier___Wireframe.self) { (_, appRouter: IAppRouter, delegate: ___VARIABLE_productName:identifier___ViewControllerDelegate) in
            ___VARIABLE_productName:identifier___Wireframe(appRouter: appRouter, delegate: delegate)
        }.inObjectScope(.transient)

        container.register(I___VARIABLE_productName:identifier___Interactor.self) { (r, view: I___VARIABLE_productName:identifier___ViewController) in
            let presenter = r.resolve(I___VARIABLE_productName:identifier___Presenter.self, argument: view)
            let manager = r.resolve(I___VARIABLE_productName:identifier___Manager.self)
            let interactor = ___VARIABLE_productName:identifier___Interactor(presenter: presenter, manager: manager)
            return interactor
        }.inObjectScope(.transient)

        container.register(I___VARIABLE_productName:identifier___Presenter.self) { (_, view: I___VARIABLE_productName:identifier___ViewController) in
            let presenter = ___VARIABLE_productName:identifier___Presenter(view: view)
            return presenter
        }.inObjectScope(.transient)

        container.register(___VARIABLE_productName:identifier___ViewController.self) { (r, appRouter: IAppRouter) in
            let bundle = Bundle(for: type(of: self))
            let view = ___VARIABLE_productName:identifier___ViewController(nibName: "___VARIABLE_productName:identifier___ViewController", bundle: bundle)
            let interactor = r.resolve(I___VARIABLE_productName:identifier___Interactor.self, argument: view as I___VARIABLE_productName:identifier___ViewController)
            let wireframe = r.resolve(I___VARIABLE_productName:identifier___Wireframe.self, arguments: appRouter, view as ___VARIABLE_productName:identifier___ViewControllerDelegate)
            view.interactor = interactor
            view.wireframe = wireframe
            return view
        }.inObjectScope(.transient)
    }
}