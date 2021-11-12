//
//  DecodedPerson.swift
//  SampleProject
//
//  Created by SICAR on 05/11/21.
//

import Foundation
import Combine

struct DecodedPerson: Codable {
    let id: String
    let name: String
    let age: Int
    let gender: String
    let pType: String
    
    
    func getPerson() -> Person {
        return RegularPerson(name: name, age: age, gender: .other(gender))
    }
}
