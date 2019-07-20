//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//  Modify By:  * Ari Munandar
//              * arimunandar.dev@gmail.com
//              * https://github.com/arimunandar

import UIKit

protocol I___VARIABLE_productName:identifier___Interactor: class {
	var parameters: [String: Any]? { get set }
}

class ___VARIABLE_productName:identifier___Interactor: I___VARIABLE_productName:identifier___Interactor {
    var presenter: I___VARIABLE_productName:identifier___Presenter?
    var manager: I___VARIABLE_productName:identifier___Manager?
    var parameters: [String: Any]?

    init(presenter: I___VARIABLE_productName:identifier___Presenter, manager: I___VARIABLE_productName:identifier___Manager) {
    	self.presenter = presenter
    	self.manager = manager
    }
}
