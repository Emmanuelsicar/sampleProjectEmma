//
//  Student.swift
//  SampleProject
//
//  Created by SICAR on 19/10/21.
//

import Foundation

struct Student: Person, Peludo {
    var peludo: Bool
    
    var id: UUID = UUID()
    
    var name: String
    
    var age: Int?
    
    var gender: Gender?
    
    var pType: PersonType = .student
    
    init(name: String, age: Int? = nil, gender: Gender? = nil) {
        self.name = name
        self.age = age
        self.gender = gender
        self.peludo = true
    }
    
    func extraInfo() -> String {
        return "Universidad de Guadalajara 👨🏽‍🎓👩🏼‍🎓"
    }
    
    
}
