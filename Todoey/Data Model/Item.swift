//
//  Item.swift
//  Todoey
//
//  Created by Claudia Dinu on 12/04/2020.
//  Copyright © 2020 test. All rights reserved.
//

import Foundation

//Encodable - the class conforms to Encodable - the Item type is now able to encode itself into a plist or into a json
//Decodable - can be decoded from another representation (eg. plist)
//Codable - the class conform both to Encodable and Decodable protocols
class Item: Codable {
    var title : String = ""
    var done : Bool = false
}
