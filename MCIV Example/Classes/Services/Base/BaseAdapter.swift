//
//  BaseAdapter.swift
//  MCIV Example
//
//  Created by Nick Ignatenko on 2019-11-22.
//  Copyright © 2019 Nick Ignatenko. All rights reserved.
//
//  A base adapter for the 'NetworkManager' class using Alamofire.

import UIKit
import PromiseKit
import Alamofire

class BaseAdapter: RequestAdapter, RequestRetrier {
    enum Endpoint {
        static let Auth     = "auth/"
        static let Token    = "token"
    }
    let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default, serverTrustPolicyManager: nil)
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        // If the 'User' model already has an access token then it will be added with the network request.
        // Noramlly, this is how to properly pass an access token to a server.
        if let accessToken = User.current.accessToken {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        return urlRequest
    }
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        self.lock.lock(); defer { self.lock.unlock() }
        if let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == InvalidTokenStatusCode,
            User.isAuthorized {
            if let refreshToken = User.current.refreshToken {
                self.requestsToRetry.append(completion)
                if !self.isRefreshing {
                    let _ = try? self.refreshTokens(refreshToken: refreshToken)
                        .then { [weak self] () -> Promise<()> in
                            guard let presenter = self else { return Promise() }
                            presenter.lock.lock() ; defer { presenter.lock.unlock() }
                            presenter.requestsToRetry.forEach { $0(true, 0.0) }
                            presenter.requestsToRetry.removeAll()
                            return Promise() // *NOTE: Need this bloody hack of returning a 'Promise' to make '.then' work!
                        }.catch { [weak self] (_) in
                            guard let presenter = self else { return }
                            presenter.lock.lock(); defer { presenter.lock.unlock() }
                            presenter.requestsToRetry.forEach { $0(false, 0.0) }
                            presenter.requestsToRetry.removeAll()
                    }
                }
            } else {
                completion(false, 0.0)
            }
        } else {
            completion(false, 0.0)
        }
    }
}

// MARK: - Actions (requests)
extension BaseAdapter {
    fileprivate func refreshTokens(refreshToken: String) throws -> Promise<()> {
        guard !isRefreshing else { throw NetError.cancel }
        self.isRefreshing = true
        return Promise()
//        return Promise<()> { [unowned self] seal in
//            let request = AuthRequest.create(url: baseURL + Endpoint.Auth + Endpoint.Token, method: .post).withRefreshToken(refreshToken)
//            self.performRequestJSON(request)
//                .then { [weak self] (json) -> Promise<()> in
//                    self?.isRefreshing = false
//                    guard let json = json as? JSON else { throw NetError.incorrectData }
//                    guard let token = (json["accessToken"] as? String) ?? (json["access_token"] as? String) else { throw NetError.noResponse }
//                    guard let refreshToken = (json["refreshToken"] as? String) ?? (json["refresh_token"] as? String) else { throw NetError.noResponse }
//                    let user = User.current
//                    user.accessToken = token
//                    user.refreshToken = refreshToken
//                    user.synchronize(inBackground: false)
//                    seal.fulfill(())
//                    return Promise() // *NOTE: Need this bloody hack of returning a 'Promise' to make '.then' work!
//                }.catch { [weak self] error in
//                    self?.isRefreshing = false
//                    seal.reject(error)
//            }
//        }
    }
    
    fileprivate func performRequestJSON(_ request: CommonRequest,
                                        validStatusCodes: [Int] = (200...299).map({$0}),
                                        requestHandler: ((DataRequest) -> Void)? = nil) -> Promise<Any?> {
        return Promise<Any?> { [unowned self] seal in
            //UIApplication.shared.delegate?.incrementActivityCounter()
            let request = self.sessionManager.request(request.url,
                                                      method: request.method,
                                                      parameters: request.parameters,
                                                      encoding: request.encoding,
                                                      headers: request.headers)
                .responseJSON(completionHandler: { (response) in
                    //UIApplication.shared.delegate?.decrementActivityCounter()
                    if validStatusCodes.contains(response.response?.statusCode ?? 0) {
                        seal.resolve(response.result.value, response.error)
                    } else {
                        seal.reject(response.error ?? NetError.unknown)
                    }
                })
            requestHandler?(request)
        }
    }
}
