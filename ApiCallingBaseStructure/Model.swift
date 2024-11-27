//
//  Model.swift
//  ApiCallingBaseStructure
//
//  Created by Sharandeep Singh on 08/09/24.
//

import Foundation

struct TokenResponse: Codable {
    
    let totalRecords: Int?
    let statusCode: Int?
    let statusMessage: String?
    let status: Bool?
    let data: String?
}

struct DefaultPost: Codable {
    
    let statusCode: Int?
    let totalRecords: Int?
    let status: Bool?
    let statusMessage: String?
}
