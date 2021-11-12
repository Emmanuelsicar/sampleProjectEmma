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
        //var sendHttp: String
        var resultPublisher: AnyPublisher<String, Error>
        
        let numeroAleatorio = Int.random(in: 1..<15)

        resultPublisher = Fail(error: ErrorValidation.errorConnection)
                .eraseToAnyPublisher()
        
        if numeroAleatorio <= 8 {
            if !self.people.contains(where: {$0.id == person.id}){
                self.people.append(person)
                resultPublisher = Just("Succes")
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
                
                print("Registro exitoso tiempo: \(numeroAleatorio)")
            }
        }

        return resultPublisher
    }
    
    
    func removePerson(at offsets: IndexSet) {
        people.remove(atOffsets: offsets)
    }
    
    func editPerson(_ person: Person) -> AnyPublisher<String, Error> {
        var resultPublisher: AnyPublisher<String, Error>
        
        let numeroAleatorio = Int.random(in: 1..<15)
        resultPublisher = Fail(error: ErrorValidation.errorConnection)
                .eraseToAnyPublisher()
        
        if numeroAleatorio <= 8 {
            if let index = people.firstIndex(where: {$0.id == person.id}) {
                resultPublisher = Just("Succes")
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
                
                print("Edicion exitosa tiempo: \(numeroAleatorio)")
                people[index] = person
            }
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
    
//    func downloadPerson() {
//        guard let url = URL(string: "https://urlrequest.000webhostapp.com/people.json") else {return}
//        URLSession.shared
//            .dataTaskPublisher(for: url)
//            .tryMap{ element -> Data in
//                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
//                    throw URLError(.badServerResponse)
//                }
//                return element.data
//            }
//            .decode(type: [DecodedPerson].self, decoder: JSONDecoder())
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: {
//                print("Received completion: \($0) ")
//                switch $0{
//                case .failure(let error):
//                    print(error)
////                    self.message = error.localizedDescription
////                    self.alertType = .failedRegister
////                    self.alertMessage = true
//                    break
//                case .finished:
////                    self.alertType = .succesful
////                    self.alertMessage = true
////                    self.updateList()
//                    break
//                }
//            }, receiveValue: { (decodedPerson) in
//                decodedPerson.forEach{
//                    print($0)
//                    self.people.append($0.getPerson())
//                }
//
//            })
//            .store(in: &cancelables)
//    }
    
}
