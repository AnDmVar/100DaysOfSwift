//
//  Countries.swift
//  Day59
//
//  Created by An Var on 19.09.2021.
//

import Foundation
import UIKit

//struct  Countries: Decodable {
//    var capital: [String?]
//    var region: String?
//}

struct  Countries: Codable {
    var name: name
    var currencies: [String:[String:String]]
    var capital: [String]
    var region: String
    var subregion: String
    var languages: [String:String]
    var translations: [String:[String:String]]
    var latlng: [Double]
    var area: Double
    var flag: String
}

struct name: Codable {
    var common: String
    var official: String
}
