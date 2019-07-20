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
import SwiftyJSON

protocol IEndpoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameter: Parameters? { get }
    var header: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}

class NetworkService {
    static let share = NetworkService()
    
    private var dataRequest: DataRequest?
    private var success: ((_ data: JSON?)->Void)?
    private var failure: ((_ error: Error?)->Void)?
    
    @discardableResult
    private func _dataRequest(
        url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest {
            return SessionManager.default.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: headers
            )
    }
    
    func request<T: IEndpoint>(endpoint: T, success: ((_ data: JSON?)->Void)? = nil, failure: ((_ error: Error?)->Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            self.dataRequest = self._dataRequest(url: endpoint.path,
                                                 method: endpoint.method,
                                                 parameters: endpoint.parameter,
                                                 encoding: endpoint.encoding,
                                                 headers: endpoint.header)
            
            self.dataRequest?.responseJSON(completionHandler: { (response) in
                
                /*
                 let statusCode = response.response?.statusCode
                 */
                
                switch response.result {
                case .success(let value):
                    success?(JSON(value))
                case .failure(let error):
                    failure?(error)
                }
            })
        }
    }
    
    func cancelRequest(_ completion: (()->Void)? = nil) {
        dataRequest?.cancel()
        completion?()
    }
    
    func cancelAllRequest(_ completion: (()->Void)? = nil) {
        dataRequest?.session.getAllTasks(completionHandler: { (tasks) in
            tasks.forEach({ (task) in
                task.cancel()
            })
        })
        completion?()
    }
    
    func success(_ completion: ((_ data: JSON?)->Void)?) -> NetworkService {
        success = completion
        return self
    }
    
    func failure(_ completion: ((_ error: Error?)->Void)?) -> NetworkService {
        failure = completion
        return self
    }
}
