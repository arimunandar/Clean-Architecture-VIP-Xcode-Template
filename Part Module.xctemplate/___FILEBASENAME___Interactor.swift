//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ Stockbit - ARI MUNANDAR. All rights reserved.

import UIKit

// MARK: - I___VARIABLE_productName:identifier___Interactor

protocol I___VARIABLE_productName:identifier___Interactor: AnyObject {
    // do someting...
}

// MARK: - ___VARIABLE_productName:identifier___Interactor

class ___VARIABLE_productName:identifier___Interactor: I___VARIABLE_productName:identifier___Interactor {
    var manager: I___VARIABLE_productName:identifier___Manager?
    var presenter: I___VARIABLE_productName:identifier___Presenter?

    init(presenter: I___VARIABLE_productName:identifier___Presenter?, manager: I___VARIABLE_productName:identifier___Manager?) {
        self.presenter = presenter
        self.manager = manager
    }
}
