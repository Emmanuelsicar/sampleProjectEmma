//
//  PeopleProvider.swift
//  SampleProject
//
//  Created by Ademar on 18/10/21.
//

import Foundation
import Combine

final class PeopleProvider {
    
    static var shared: PeopleProvider = PeopleProvider()
    
    var people: [Person] = []
    var errores: ErrorValidation = .errorConnection
    var cancelables: Set<AnyCancellable> = []
    let repository: Repository = Repository.shared
    
    func fillRandomly() {
        var randomPeople: [Person] = []
        for i in people.count..<Int.random(in: (people.count + 1)...(people.count + 8)) {
            let randomInt = Int.random(in: 1...8)
            var temp: Person = RegularPerson(name: "Fill RandomLy \(i)")
            temp.age = i + 10 * randomInt
            temp.gender = ((randomInt % 2) > 0 ? .male : .female)
            randomPeople.append(temp)
        }
        people.append(contentsOf: randomPeople)
    }
    
    func getPeopleAPI() {
        repository.downloadPerson()
        repository.arrayDecodedPerson.forEach { (DecodedPerson) in
            if !people.contains(where: {$0.id == DecodedPerson.getPerson().id}){
                people.append(DecodedPerson.getPerson())
                print("Descarga exitosa")
            }else{
                print("Repetido")
            }
        }
    }
    
    func getPeoplePublisher(_ search: String, _ order: ReturnOrder? = nil, _ factor: OrderFactor? = nil) -> AnyPublisher <[Person], Never> {
        var resultPublisher: AnyPublisher<[Person], Never>
        var orderPeople: [Person] = []
        resultPublisher = Just(orderPeople)
            .eraseToAnyPublisher()
        getPeopleAPI()
        if search != "" {
            orderPeople = self.filter(people, search: search)
            resultPublisher = Just(orderPeople)
                .eraseToAnyPublisher()
        } else {
            if let opcional = order, let opcional2 = factor {
                orderPeople = self.order(people, order: opcional, factor: opcional2)
              resultPublisher = Just(orderPeople)
                    .eraseToAnyPublisher()
            }
        }
         
        return resultPublisher
    }
    
    deinit {
        print("Desiniciando")
    }
}
