//
//  RegularPerson.swift
//  SampleProject
//
//  Created by Ademar on 18/10/21.
//

import Foundation

struct RegularPerson: Person {
    var id: UUID = UUID()
    
    var name: String
    
    var age: Int?
    
    var gender: Gender?
    
    var pType: PersonType = .averageJoe
    
    init(name: String, age: Int? = nil, gender: Gender? = nil) {
        self.name = name
        self.age = age
        self.gender = gender
    }
    
    func extraInfo() -> String {
        return "Regular person 🙎🏽‍♂️ 🙍🏼‍♀️"
    }
    
    
}
