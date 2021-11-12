//
//  Teacher.swift
//  SampleProject
//
//  Created by SICAR on 19/10/21.
//

import Foundation
struct Teacher: Person {
    var id: UUID = UUID()
    
    var name: String
    
    var age: Int?
    
    var gender: Gender?
    
    var pType: PersonType = .teacher
    
    init(name: String, age: Int? = nil, gender: Gender? = nil) {
        self.name = name
        self.age = age
        self.gender = gender
    }
    
    func extraInfo() -> String {
        return "El Master 👨🏻‍🏫👩🏼‍🏫"
    }
    
    
}
