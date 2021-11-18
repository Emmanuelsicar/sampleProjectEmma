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
    
    private var cancelables: Set<AnyCancellable> = []
    public var arrayDecodedPerson: [DecodedPerson] = []
    private let host = "https://urlrequest.000webhostapp.com"
    
    func downloadPerson(){
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
                        break
                    case .finished:
                        print($0)
                        print("Finished")
                        break
                    }
                }, receiveValue: { (decodedPerson) in
                    decodedPerson.forEach{
                        print($0)
                    }
                    self.arrayDecodedPerson = decodedPerson
                })
                .store(in: &cancelables)         
        }
    
    func deletePerson(id: UUID){
        guard let url = URL(string: "\(host)/delete.php/?id=\(id.uuidString)") else {return}
          
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
             
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
             
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
          
        }
        
        task.resume()
    }
    
    func editPerson(person: Person){
        guard let url = URL(string: "\(host)/update.php") else {return}
        let person = person
        var request = URLRequest(url: url)
            
        request.httpMethod = "POST"
        guard let age = person.age else {
            return
        }
        guard let gender = person.gender else {
            return
        }
        let parameters: [String: Any] = [
            "id": person.id.uuidString,
            "name": person.name,
            "age": age,
            "gender" : gender.value,
            "pType": person.pType.valueName
        ]
        
        request.httpBody = parameters.percentEncoded()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
              
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
           
        }
        
        task.resume()
        
    }
    
    func postPerson(_ person: Person, onSucc: @escaping () -> Void, onFail: @escaping () -> Void){
        guard let url = URL(string: "\(host)/register.php") else {return}
        let person = person
        var request = URLRequest(url: url)
            
        request.httpMethod = "POST"
        guard let age = person.age else {
            return
        }
        guard let gender = person.gender else {
            return
        }
        let parameters: [String: Any] = [
            "id": person.id.uuidString,
            "name": person.name,
            "age": age,
            "gender" : gender.value,
            "pType": person.pType.valueName
        ]
        
        request.httpBody = parameters.percentEncoded()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                onFail()
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                onFail()
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            onSucc()
        }
        
        task.resume()
    }
    
    
}
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            print(escapedKey + "=" + escapedValue)
            return escapedKey + "=" + escapedValue
            
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
