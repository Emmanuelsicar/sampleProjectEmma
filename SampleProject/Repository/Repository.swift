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
    let host = "https://urlrequest.000webhostapp.com"
    
    func downloadPerson(onSucc: @escaping (Bool, [DecodedPerson]) -> Void , onFail: @escaping () -> Void){
        let path = "/people.json"
        guard let url = URL(string: "\(host)\(path)") else {return}
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
                        onFail()
                        break
                    case .finished:
                        print($0)
                        print("Finished")
                        onSucc(true, self.array)
                        break
                    }
                }, receiveValue: { (decodedPerson) in
                    decodedPerson.forEach{
                        print($0)
                    }
                    self.array = decodedPerson
                })
                .store(in: &cancelables)         
        }

    func uploadPerson(_ name: String, _ age: Int, _ gender: Gender, onSucc: @escaping () -> Void, onFail: @escaping () -> Void){
       let person = RegularPerson(name: name, age: age, gender: gender)
        if let opcional1 = person.age, let opcional2 = person.gender{
            let path = "/register.php?id=\(person.id)&name=\(person.name)&age=\(opcional1)&gender=\(opcional2.value)&pType=\(person.pType.rawValue)"
            guard let url = URL(string: "\(host)\(path)") else {return}
            URLSession.shared
                .dataTaskPublisher(for: url)
                .tryMap{ element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: {
                    print("Received completion: \($0) ")
                    switch $0{
                    case .failure(let error):
                        print(error)
                        onFail()
                        break
                    case .finished:
                        onSucc()
                        break
                    }
                }, receiveValue: { (decodedPerson) in
                    decodedPerson.forEach{
                        print($0)
                    }
                    
                })
                .store(in: &cancelables)
        } else {
            print("Los valores no pueden ser nil")
        }
       
    }
    
    
}
