//
//  Parser.swift
//  BKKZ
//
//  Created by Yerassyl Zhassuzakhov on 1/7/19.
//  Copyright © 2019 Nursultan. All rights reserved.
//

import Foundation
import Alamofire

public protocol Parser {
    func parse<T: Decodable>(response: DataResponse<Any>) -> Result<T>
}

public extension Parser {
    private func serializeStatusCode(_ statusCode: Int) -> String {
        var error: Error
        switch statusCode {
        case 100..<200:
            error = CustomError.informationalError
        case 300..<400:
            error = CustomError.redirectionError
        case 400..<500:
            error = CustomError.notFoundError
        case 500..<600:
            error = CustomError.serverError
        default:
            error = CustomError.unknownError
        }
        
        return error.localizedDescription
    }
    
    func parse<T: Decodable>(response: DataResponse<Any>) -> Result<T> {
        print(response)
        switch response.result {
        case .failure(let error):
            if let statusCode = response.response?.statusCode {
                let message = serializeStatusCode(statusCode)
                
                return Result.failure(message)
            } else {
                return Result.failure(error.localizedDescription)
            }
        case .success(_):
            if let result = response.result.value {
                if JSONSerialization.isValidJSONObject(result) {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: result, options: [])
                        let retrievingData = try JSONDecoder().decode(T.self, from: data)
                        
                        return Result.success(retrievingData)
                    } catch {
                        return Result.failure(error.localizedDescription)
                    }
                } else {
                    return Result.failure("Result is not a valid JSON object")
                }
            } else {
                return Result.failure("Ошибка при обработке данных!")
            }
        }
    }
}
