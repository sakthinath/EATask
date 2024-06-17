//
//  EndPointProtocol.swift
//  NetworkLayer
//
//  Created by Sathyanath Masthan on 04/04/23.
//  Copyright © 2018 Sathyanath Masthan. All rights reserved.
//

import Foundation

protocol EndPointProtocol {
    var baseURL : URL {get}
    var path : String {get}
    var httpMethod : HTTPMethod {get}
    var task : HTTPTask {get}
    var headers : HTTPHeaders? {get}
}
