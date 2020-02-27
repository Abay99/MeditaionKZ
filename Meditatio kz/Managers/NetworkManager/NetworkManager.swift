//
//  NetworkManager.swift
//  BKKZ
//
//  Created by Yerassyl Zhassuzakhov on 1/7/19.
//  Copyright © 2019 Nursultan. All rights reserved.
//

import Foundation
import Alamofire

public class NetworkManager {
    let parser: Parser
    
    public init(parser: Parser) {
        self.parser = parser
    }
    
    public init() {
        self.parser = CustomParser()
    }
    
    public func makeRequest<T: Decodable>(endpoint: EndPointType, completion: @escaping (Result<T>) -> Void) {
        let urlString = (endpoint.baseURL + endpoint.path).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString!)!
        print(url)
//        print(endpoint.headers)
        switch endpoint.httpTask {
        case .request:
            Alamofire.request(url, method: endpoint.httpMethod, encoding: JSONEncoding.default, headers: endpoint.headers).validate(statusCode: 200..<300).responseJSON { (response) in
                completion(self.parser.parse(response: response))
            }
            
        case .requestWithParameters(let parameters):
            print(parameters)
            print(url)
            Alamofire.request(url, method: endpoint.httpMethod, parameters: parameters, headers: endpoint.headers)
                .validate(statusCode: 200..<500).responseJSON { (response) in
                    completion(self.parser.parse(response: response))
            }
            
        case let .requestWithMultipartData(data, parameters, parameterName):
            print(parameters)
            print(data)
            print(parameterName)
            Alamofire.upload(multipartFormData: { (multipartData) in
                for (key, value) in parameters {
                    if value is [String] {
                        for newValue in value as! [String] {
                            multipartData.append((newValue).data(using: .utf8)!, withName: key)
                        }
                    } else if let intArray = value as? [Int] {
                        for newValue in intArray {
                            multipartData.append(("\(newValue)").data(using: .utf8)!, withName: key)
                        }
                    } else if value is String || value is Int {
                        multipartData.append(("\(value)").data(using: .utf8)!, withName: key)
                    }
                }
                if let array = data as? [Data] {
                    for data in array {
                        multipartData.append(data, withName: parameterName, fileName: UUID().uuidString + ".png", mimeType: "image/png")
                    }
                } else if let data = data as? Data {
                    
                    multipartData.append(data, withName: parameterName, fileName: UUID().uuidString + ".png", mimeType: "image/png")
                }
            }, usingThreshold: UInt64(), to: url, method: endpoint.httpMethod, headers: endpoint.headers, encodingCompletion: { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    print(12435)
                    upload.validate(statusCode: 200..<500).responseJSON(completionHandler: { (response) in
                        completion(self.parser.parse(response: response))
                    })
                }
            })
        case let .requestWithMultipartDatas(datas, parameters):
            Alamofire.upload(multipartFormData: { (multipartData) in
                for (key, value) in parameters {
                    if value is [String] {
                        for newValue in value as! [String] {
                            multipartData.append((newValue).data(using: .utf8)!, withName: key)
                        }
                    } else if let intArray = value as? [Int] {
                        for newValue in intArray {
                            multipartData.append(("\(newValue)").data(using: .utf8)!, withName: key)
                        }
                    } else if value is String || value is Int {
                        multipartData.append(("\(value)").data(using: .utf8)!, withName: key)
                    }
                }
                for (key, value) in datas {
                    if let array = value as? [Data] {
                        for i in 0..<array.count {
                            let data = array[i]
                            multipartData.append(data, withName: key, fileName: UUID().uuidString + ".jpg", mimeType: "image/jpg")
                        }
                    } else if let data = value as? Data {
                        multipartData.append(data, withName: key, fileName: UUID().uuidString + ".jpg", mimeType: "image/jpg")
                    }
                }
            }, usingThreshold: UInt64(), to: url, method: .patch, headers: endpoint.headers, encodingCompletion: { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    upload.validate(statusCode: 200..<300).responseJSON(completionHandler: { (response) in
                        completion(self.parser.parse(response: response))
                    })
                }
            })
        }
    }
}

