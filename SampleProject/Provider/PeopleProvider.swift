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
    
    func getPeoplePublisher(_ search: String, _ order: ReturnOrder? = nil, _ factor: OrderFactor? = nil) -> AnyPublisher <[Person], Never> {
        var resultPublisher: AnyPublisher<[Person], Never>
        var orderPeople: [Person] = []
        resultPublisher = Just(orderPeople)
            .eraseToAnyPublisher()
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
