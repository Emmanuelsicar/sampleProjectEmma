//
//  Repository.swift
//  SampleProject
//
//  Created by SICAR on 11/11/21.
//

import Foundation
import Combine

final class Repository {
    public static var shared: Repository = Repository()
    
    var cancelables: Set<AnyCancellable> = []
    var array: [DecodedPerson] = []
    
    func downloadPerson(clausura: @escaping (Bool) -> Void){
        //var publicador: AnyPublisher<[DecodedPerson], Error>
        guard let url = URL(string: "https://urlrequest.000webhostapp.com/people.json") else {return}
      
            URLSession.shared
                .dataTaskPublisher(for: url)
                .tryMap{ element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: [DecodedPerson].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: {
                    print("Received completion: \($0) ")
                    switch $0{
                    case .failure(let error):
                        print(error)
                        clausura(false)
                      //  publicador = Fail(error: ErrorValidation.errorConnection)
                           // .eraseToAnyPublisher()
                        
                        break
                    case .finished:
                        print($0)
                        clausura(true)
                        break
                    }
                }, receiveValue: { (decodedPerson) in
                    decodedPerson.forEach{
                        print($0)
                        //arrayPerson.append($0.getPerson())
                    }
                    self.array = decodedPerson
                })
                .store(in: &cancelables)
        
       // return publicador
        }
   
    
}
