//
//  BResponse.swift
//  WebViewTest
//
//  Created by Blezin on 23.12.2020.
//  Copyright © 2020 Blezin'sDev. All rights reserved.
//

import Foundation

struct BResponse: Decodable {
    let type: String
    let contents: String?
    let url: String?
}
