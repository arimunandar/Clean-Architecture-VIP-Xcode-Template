//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//  Modify By:  * Ari Munandar
//              * arimunandar.dev@gmail.com
//              * https://github.com/arimunandar

import Foundation
import Swinject

class ___VARIABLE_productName:identifier___Assembly: Assembly {
	func assemble(container: Container) {
		container.register(___VARIABLE_productName:identifier___ViewController.self) { (r, parameters: [String: Any]) in
			let view = ___VARIABLE_productName:identifier___ViewController()
			let interactor = r.resolve(I___VARIABLE_productName:identifier___Interactor.self, argument: view as I___VARIABLE_productName:identifier___ViewController)!
			let router = r.resolve(I___VARIABLE_productName:identifier___Router.self, argument: view)!
			interactor.parameters = parameters
			view.interactor = interactor
			view.router = router
			return view
		}

		container.register(I___VARIABLE_productName:identifier___Interactor.self) { (r, view: I___VARIABLE_productName:identifier___ViewController) in			
			let presenter = r.resolve(I___VARIABLE_productName:identifier___Presenter.self, argument: view)!
			let manager = r.resolve(I___VARIABLE_productName:identifier___Manager.self)!
			let interactor = ___VARIABLE_productName:identifier___Interactor(presenter: presenter, manager: manager)
			return interactor
		}

		container.register(I___VARIABLE_productName:identifier___Presenter.self) { (r, view: I___VARIABLE_productName:identifier___ViewController) in
			return ___VARIABLE_productName:identifier___Presenter(view: view)
		}

		container.register(I___VARIABLE_productName:identifier___Router.self) { (r, view: ___VARIABLE_productName:identifier___ViewController) in
			return ___VARIABLE_productName:identifier___Router(view: view)
		}

		container.register(I___VARIABLE_productName:identifier___Manager.self) { r in
			return ___VARIABLE_productName:identifier___Manager()
		}
	}
}
