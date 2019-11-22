//
//  NetworkManager.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  Base network manager that is used to perform network requests.

import UIKit
import Alamofire
import PromiseKit

class NetworkManager {
    static let domain: String = "domain.network.manager"
    static let configuration: URLSessionConfiguration = URLSessionConfiguration.default
    let sessionManager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: nil)
    
    init() {
        self.sessionManager.adapter = BaseAdapter()
    }
}

// MARK: Actions (requests)
extension NetworkManager {
    func performRequestJSON(_ request: CommonRequest,
                            validStatusCodes: [Int] = (200...299).map({$0}),
                            requestHandler: ((DataRequest) -> ())? = nil) -> Promise<Any?> {
        return Promise<Any?> { [unowned self] seal in
            //UIApplication.shared.delegate?.incrementActivityCounter()
            let sessionRequest = self.sessionManager.request(request.url,
                                                             method: request.method,
                                                             parameters: request.parameters,
                                                             encoding: request.encoding,
                                                             headers: request.headers)
                //.validate(contentType: ["application/x-www-form-urlencoded"]).validate(contentType: ["application/json"])
                .responseJSON(completionHandler: { (response) in
                    //UIApplication.shared.delegate?.decrementActivityCounter()
                    // TODO: Figure out if perhaps LOGGING these responses might be a good idea (for debugging purposes) for your project?
                    if validStatusCodes.contains(response.response?.statusCode ?? 0) {
                        seal.resolve(response.result.value, response.error)
                    } else {
                        seal.reject(NetworkManager.parseError(error: response.error ?? NetError.unknown, response: response))
                    }
                })
            requestHandler?(sessionRequest)
        }
    }
    
    func performRequestString(_ request: CommonRequest) -> Promise<String?> {
        return Promise<String?> { [unowned self] seal in
            //UIApplication.shared.delegate?.incrementActivityCounter()
            self.sessionManager.request(request.url,
                                        method: request.method,
                                        parameters: request.parameters,
                                        encoding: request.encoding,
                                        headers: request.headers)
                .validate()
                .responseString(completionHandler: { (response) in
                    //UIApplication.shared.delegate?.decrementActivityCounter()
                    switch (response.result) {
                    case .success(let result):
                        seal.resolve(result, response.error)
                        break
                    case .failure(let error):
                        seal.reject(NetworkManager.parseError(error: error, response: response))
                    }
                })
        }
    }
    
    func performRequestData(_ request: CommonRequest) -> Promise<Data?> {
        return Promise<Data?> { [unowned self] seal in
            //UIApplication.shared.delegate?.incrementActivityCounter()
            self.sessionManager.request(request.url,
                                        method: request.method,
                                        parameters: request.parameters,
                                        encoding: request.encoding,
                                        headers: request.headers)
                .validate()
                .responseString(completionHandler: { (response) in
                    //UIApplication.shared.delegate?.decrementActivityCounter()
                    switch (response.result) {
                    case .success( _):
                        seal.resolve(response.data, response.error)
                        break
                    case .failure(let error):
                        seal.reject(NetworkManager.parseError(error: error, response: response))
                    }
                })
        }
    }
    
    func performMultipartRequest(_ request: MultipartRequest,
                                 validStatusCodes: [Int] = (200...299).map({$0}),
                                 progressHandler: ((_ fractionCompleted: Double) -> Void)? = nil) -> Promise<Any?> {
        return Promise<Any?> { [unowned self] seal in
            //UIApplication.shared.delegate?.incrementActivityCounter()
            self.sessionManager.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in request.parameters {
                    if let representation = request.fileRepresentations[key] {
                        multipartFormData.append(value as! Data, withName: key, fileName: representation.fileName, mimeType: representation.mimeType)
                    } else {
                        multipartFormData.append(value as! Data, withName: key)
                    }
                }
            },
                                       to: request.url,
                                       method: request.method,
                                       headers: request.headers,
                                       encodingCompletion: { (encodingResult) in
                                        switch encodingResult {
                                        case .success(let upload, _, _):
                                            upload.uploadProgress(closure: { (progress) in
                                                progressHandler?(progress.fractionCompleted)
                                            })
                                            upload.responseJSON(completionHandler: { (response) in
                                                //UIApplication.shared.delegate?.decrementActivityCounter()
                                                // TODO: Find out if perhaps LOGGING these responses might be a good idea (for debugging purposes)?
                                                if validStatusCodes.contains(response.response?.statusCode ?? 0) {
                                                    seal.resolve(response.result.value, response.error)
                                                } else {
                                                    seal.reject(NetworkManager.parseError(error: response.error ?? NetError.unknown, response: response))
                                                }
                                            })
                                        case .failure(let encodingError):
                                            //UIApplication.shared.delegate?.decrementActivityCounter()
                                            seal.reject(encodingError)
                                        }
            })
        }
    }
}

// MARK: Actions (error parsing)
extension NetworkManager {
    fileprivate static func parseError<T>(error: Error, response: DataResponse<T>) -> NSError {
        let errors = try? ((response.result.value as? JSON)?["errors"] as? [JSON])?.createModels(ResponseErrorModel.self)
        if error.isCancelled {
            return error as NSError
        } else {
            return NSError(domain: "com.solicitrr.network",
                           code: response.response?.statusCode ?? (error as NSError).code,
                           userInfo: ["message": errors?.first?.message ?? "Unknown_Error".localized])
        }
    }
}

