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
        case PersonType.averageJoe.rawValue, "AverageJoe":
            person = RegularPerson(name: name, age: age, gender: .other(gender))
            if let opcional = UUID.init(uuidString: self.id){
                person.id = opcional
            }
            return person
        case PersonType.parent.rawValue, "Parent":
            person = Parent(name: name, age: age, gender: .other(gender))
            if let opcional = UUID.init(uuidString: self.id){
                person.id = opcional
            }
            return person
        case PersonType.student.rawValue, "Student":
            person = Student(name: name, age: age, gender: .other(gender))
            if let opcional = UUID.init(uuidString: self.id){
                person.id = opcional
            }
            return person
        case PersonType.teacher.rawValue, "Teacher":
            person = Teacher(name: name, age: age, gender: .other(gender))
            if let opcional = UUID.init(uuidString: self.id){
                person.id = opcional
            }
            return person
        case PersonType.principal.rawValue, "Principal":
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
