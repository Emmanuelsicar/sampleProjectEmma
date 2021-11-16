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
        var person: Person
    
        switch pType {
        case PersonType.averageJoe.rawValue:
            person = RegularPerson(name: name, age: age, gender: .other(gender))
            if let opcional = UUID.init(uuidString: self.id){
                person.id = opcional
            }
            return person
        case PersonType.parent.rawValue:
            person = Parent(name: name, age: age, gender: .other(gender))
            if let opcional = UUID.init(uuidString: self.id){
                person.id = opcional
            }
            return person
        case PersonType.student.rawValue:
            person = Student(name: name, age: age, gender: .other(gender))
            if let opcional = UUID.init(uuidString: self.id){
                person.id = opcional
            }
            return person
        case PersonType.teacher.rawValue:
            person = Teacher(name: name, age: age, gender: .other(gender))
            if let opcional = UUID.init(uuidString: self.id){
                person.id = opcional
            }
            return person
        case PersonType.principal.rawValue:
            person = Principal(name: name, age: age, gender: .other(gender))
            if let opcional = UUID.init(uuidString: self.id){
                person.id = opcional
            }
            return person
        default:
            return RegularPerson(name: name, age: age, gender: .other(gender))
        }
    }
}
