//
//  PeopleProvider + Extension.swift
//  SampleProject
//
//  Created by Ademar on 18/10/21.
//

import Foundation
import Combine

extension PeopleProvider {
    
    func addPerson(_ person: Person) -> AnyPublisher<String, Error> {
        var resultPublisher: AnyPublisher<String, Error>
        
        resultPublisher = Just("Nothing")
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        if !self.people.contains(where: {$0.id == person.id}){
            self.repository.postPerson(person) {
                self.people.append(person)
                resultPublisher = Just("Succes")
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
                
                print("Registro exitoso")
                
            } onFail: {
                resultPublisher = Fail(error: ErrorValidation.errorConnection)
                        .eraseToAnyPublisher()
            }
        }else{
            resultPublisher = Just("Repeat")
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return resultPublisher
    }
    
    
    func removePerson(at offsets: IndexSet) {
        if let opcional = offsets.first{
            print(people[opcional])
            repository.deletePerson(id: people[opcional].id)
        }
        people.remove(atOffsets: offsets)
    }
    
    func editPerson(_ person: Person) -> AnyPublisher<String, Error> {
        var resultPublisher: AnyPublisher<String, Error>
        
        resultPublisher = Just("Nothing")
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        
        if let index = people.firstIndex(where: {$0.id == person.id}) {
            resultPublisher = Just("Succes")
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            repository.editPerson(person: person)
            print("Edicion exitosa")
            people[index] = person
        }

        return resultPublisher
    }
    
    
    func removeAllPerson() {
        people.removeAll()
    }
    
    func filter(_ people: [Person], search: String) -> [Person] {
        var arrayPeopleSearch: [Person] = []

        if search != ""{
            for elemento in people {
                if elemento.name.contains(search){
                    arrayPeopleSearch.append(elemento)
                }
            }
        }
        
        return arrayPeopleSearch
    }
    
    func order(_ people: [Person], order: ReturnOrder, factor: OrderFactor) -> [Person] {
        var arrayPeople: [Person] = []
        
        switch (order, factor) {
        case (.asc, .name):
            arrayPeople = people.sorted(by: { $0.name < $1.name })
        case (.desc, .name):
            arrayPeople = people.sorted(by: { $0.name > $1.name })
        case (.asc, .age):
            arrayPeople = people.sorted(by: { (persona1, persona2) -> Bool in
                               
                if let opcional = persona1.age, let opcional2 = persona2.age{
                    return opcional  < opcional2
                }
                return false
            })
        case (.desc, .age):
            arrayPeople = people.sorted(by: { (persona1, persona2) -> Bool in
                               
                if let opcional = persona1.age, let opcional2 = persona2.age{
                    return opcional  > opcional2
                }
                return false
            })
        case (.asc, .gender):
           arrayPeople = people.sorted(by: { (persona1, persona2) -> Bool in
                               
                if let opcional = persona1.gender?.value, let opcional2 = persona2.gender?.value{
                    return opcional  < opcional2
                }
                return false
            })
        case (.desc, .gender):
           arrayPeople = people.sorted(by: { (persona1, persona2) -> Bool in
                               
                if let opcional = persona1.gender?.value, let opcional2 = persona2.gender?.value{
                    return opcional  > opcional2
                }
                return false
            })
        case (.asc, .personType):
            arrayPeople = people.sorted(by: { $0.pType.rawValue < $1.pType.rawValue})
        case (.desc, .personType):
            arrayPeople = people.sorted(by: { $0.pType.rawValue > $1.pType.rawValue })
        case (.rand, _):
            arrayPeople = people.shuffled()
        }
        return arrayPeople
    }
    
}
