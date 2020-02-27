//
//  CustomError.swift
//  BKKZ
//
//  Created by Yerassyl Zhassuzakhov on 1/7/19.
//  Copyright © 2019 Nursultan. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case informationalError
    case redirectionError
    case notFoundError
    case serverError
    case unknownError
}

extension CustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .informationalError:
            return "Informational error"
        case .redirectionError:
            return "Redirected"
        case .notFoundError:
            return "Not found"
        case .serverError:
            return "Internal server error"
        default:
            return "Unknown error"
        }
    }
}
