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
import Alamofire

enum ___VARIABLE_productName:identifier___Endpoint {
    /*
     Add Endpoint
     case login
     case login(parameter: [String: Any])
    */
}

extension ___VARIABLE_productName:identifier___Endpoint: IEndpoint {
    var method: HTTPMethod {
        /*
        Do like this:

        switch self {
        case .login:
            return .get
        }
        */
        return .get
    }
    
    var path: String {
        /*
        Do like this:

        switch self {
        case .login:
            return "https://httpbin.org/get"
        }
        */
        return ""
    }
    
    var parameter: Parameters? {
        /*
        Do like this:

        switch self {
        case .login(let model):
            return model.parameter()
        }
        */
        return nil
    }
    
    var header: HTTPHeaders? {
        /*
        Do like this:

        switch self {
        case .login:
            return ["key": Any]
        }
        */
        return nil
    }
    
    var encoding: ParameterEncoding {
        
        /*
        Do like this:
        
        return URLEncoding.queryString for URL Query
        
        switch self {
        case .login:
            return JSONEncoding.default
        }
        */
        return JSONEncoding.default
    }
}
