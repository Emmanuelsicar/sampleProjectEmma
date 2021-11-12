//
//  Principal.swift
//  SampleProject
//
//  Created by SICAR on 19/10/21.
//

import Foundation

struct Principal: Person {
    var id: UUID = UUID()
    
    var name: String
    
    var age: Int?
    
    var gender: Gender?
    
    var pType: PersonType = .principal
    
    init(name: String, age: Int? = nil, gender: Gender? = nil) {
        self.name = name
        self.age = age
        self.gender = gender
    }
    
    func extraInfo() -> String {
        return "El mero principal 😎"
    }
    
    
}
