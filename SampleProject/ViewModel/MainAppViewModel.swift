//
//  MainAppViewModel.swift
//  SampleProject
//
//  Created by Ademar on 18/10/21.
//

import Foundation
import Combine
import SwiftUI

class MainAppViewModel: ObservableObject {
    
    let provider: PeopleProvider = PeopleProvider.shared
    
    let repository: Repository = Repository.shared
    
    @Published var peopleList: [Person] = []
    
    @Published var filterText: String = ""
    
    @Published var selectedOrder: ReturnOrder = .asc
    
    @Published var selectedFactor: OrderFactor = .age
    
    @Published var alertMessage: Bool = false
    
    var message = ""
    
    var alertType: AlertMessage = .unknowGender
    
    private var cancelables: Set<AnyCancellable> = []
    
    
    func updateList() {
        provider.getPeoplePublisher(filterText, selectedOrder, selectedFactor)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print(error)
                    print("La cagaste")
                    break
                case .finished:
                    //print("Datos bien recolectados")
                    break
                }
            } receiveValue: { (value) in
                self.peopleList = value
            }
            .store(in: &cancelables)
    }
    
    func fillRandomly() {
        var randomPeople: [Person] = []
        for i in provider.people.count..<Int.random(in: (provider.people.count + 1)...(provider.people.count + 8)) {
            let randomInt = Int.random(in: 1...8)
            var temp: Person = RegularPerson(name: "Fill RandomLy \(i)")
            temp.age = i + 10 * randomInt
            temp.gender = ((randomInt % 2) > 0 ? .male : .female)
            randomPeople.append(temp)
        }
        provider.people.append(contentsOf: randomPeople)
        updateList()
    }
    
    func deletePerson(at offsets: IndexSet) {
        provider.removePerson(at: offsets)
        updateList()
    }
    
    func clearAll() {
        alertType = .deleteAll
        alertMessage = true
    }
    
    func deleteAllPerson() {
        provider.removeAllPerson()
        updateList()
    }
    
    func addDownloadPerson(){
     //downloadPerson()
        
    
        repository.downloadPerson { [unowned self] value in
            if value {
                repository.array.forEach { (DecodedPerson) in
                    provider.people.append(DecodedPerson.getPerson())
                }
                self.updateList()
                self.alertType = .succesful
                self.alertMessage = true
            } else {
                self.alertType = .failedRegister
                self.alertMessage = true
            }
        }
        

        
    }
    
    deinit {
        print("Good bye")
    }
    
    func generateAlert(_ alertMessage: AlertMessage) -> Alert {
        var atention = Alert(title: Text("Message"), message: Text("Generic Alert"))
        
        switch alertMessage {
        case .failedRegister:
            atention = Alert(title: Text("Failed 🙁"), message: Text("\(alertMessage.rawValue), \(message)"))
        case .succesful:
            atention = Alert(title: Text("Succes 😄"), message: Text(alertMessage.rawValue))
        case .deleteAll:
            atention = Alert(title: Text("Caution ⚠️"), message: Text("Are you sure you delete all people?"), primaryButton: Alert.Button.default(Text("Continue"), action: {
                print("Eliminado")
                self.deleteAllPerson()
                self.updateList()
            }), secondaryButton: Alert.Button.cancel(Text("Cancel")))
        default:
          print("nil")
        break
        }
        
        return atention
    }
    
    
    
    func downloadPerson() {
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
//                    self.message = error.localizedDescription
//                    self.alertType = .failedRegister
//                    self.alertMessage = true
                    break
                case .finished:
//                    self.alertType = .succesful
//                    self.alertMessage = true
//                    self.updateList()
                    break
                }
            }, receiveValue: { (decodedPerson) in
                decodedPerson.forEach{
                    print($0)
                    self.provider.people.append($0.getPerson())
                }
                
            })
            .store(in: &cancelables)
    }
}
