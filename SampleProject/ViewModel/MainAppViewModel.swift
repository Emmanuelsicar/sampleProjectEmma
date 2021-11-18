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
                  
                    break
                }
            } receiveValue: { (value) in
                self.peopleList = value
            }
            .store(in: &cancelables)
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

}
