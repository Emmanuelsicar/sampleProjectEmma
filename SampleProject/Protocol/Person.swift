//
//  Person.swift
//  SampleProject
//
//  Created by Ademar on 18/10/21.
//

import Foundation

protocol Person {
    var id: UUID {get set}
    var name: String {get set}
    var age: Int? {get set}
    var gender: Gender? {get set}
    var pType: PersonType {get set}
    
    func extraInfo() -> String
}
