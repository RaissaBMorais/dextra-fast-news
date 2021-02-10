//
//  HotNewsProvider.swift
//  Fast News
//
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import Foundation
import Alamofire

class HotNewsProvider: ProviderProcotol {
    //MARK: - Constants
    
    // Hot News endpoint
    private let kHotNewsEndpoint = "/r/ios/hot/.json"
    // Comments endpoint
    private let kCommentsEndpoint = "/r/ios/comments/@.json"

    //MARK: - Singleton
    
    static let shared = HotNewsProvider()
    
    //MARK: - Public Methods

    func hotNews(parameters: [String: Any]? = nil, completion: @escaping HotNewsCallback) {
        let alamofire = APIProvider.shared.sessionManager
        let requestString = APIProvider.shared.baseURL() + kHotNewsEndpoint

        do {
            let requestURL = try requestString.asURL()
            
            let headers: HTTPHeaders = APIProvider.shared.baseHeader()
            
            alamofire.request(requestURL, method: .get, parameters: parameters,
                              encoding: URLEncoding.queryString,
                              headers: headers).responseJSON { (response) in
                
                switch response.result {
                case let .success(jsonData):
                    
                    do {
                        if let hotNewsDict = jsonData as? [String: AnyObject],
                            let dataArray = hotNewsDict["data"] as? [String: AnyObject] {
                            let data = try JSONSerialization.data(withJSONObject: dataArray as Any, options: .prettyPrinted)
                            let items = try JSONDecoder().decode(HotNewsResponse.self, from: data)
                            completion { return items }
                        } else {
                            completion { return nil }
                        }
                    } catch {
                        completion { throw error }
                    }
                    break
                case .failure(let error):
                    completion { throw error }
                    break
                }
            }
        } catch {
            completion { throw error }
        }
    }
    
    func hotNewsComments(id: String, completion: @escaping HotNewsCommentsCallback) {
        let alamofire = APIProvider.shared.sessionManager
        let endpoint = kCommentsEndpoint.replacingOccurrences(of: "@", with: id)
        let requestString = APIProvider.shared.baseURL() + endpoint
        
        do {
            let requestURL = try requestString.asURL()
            
            let headers: HTTPHeaders = APIProvider.shared.baseHeader()
            
            alamofire.request(requestURL, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case let .success(jsonData):
                    
                    do {
                        if let hotNewsDict = jsonData as? [[String: AnyObject]],
                            let dataArray = hotNewsDict.last?["data"] as? [String: AnyObject] {
                            let data = try JSONSerialization.data(withJSONObject: dataArray as Any, options: .prettyPrinted)
                            let items = try JSONDecoder().decode(CommentsResponse.self, from: data)
                            completion { return items }
                        } else {
                            completion { return nil }
                        }
                    } catch {
                        completion { throw error }
                    }
                    
                case .failure(let error):
                    completion { throw error }
                    break
                }
            }
        } catch {
            completion { throw error }
        }
    }
}
