//
//  Petition.swift
//  Project7
//
//  Created by An Var on 02.03.2021.
//

import Foundation

//названия совпадают с названиями в JSON
struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
                                                               
