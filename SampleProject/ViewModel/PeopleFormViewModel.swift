//
//  PeopleFormViewModel.swift
//  SampleProject
//
//  Created by SICAR on 04/11/21.
//

import Foundation
import Combine
import SwiftUI

class PeopleFormViewModel: ObservableObject {
    
    let type: PersonType
    
    let provider: PeopleProvider = PeopleProvider.shared
    
    let repository: Repository = Repository.shared
    
    @Published var activateMessage: Bool = false
    
    @Published var name: String = ""
    
    @Published var age: String = ""
    
    @Published var gender: Gender = .male
    
    @Published var otherText: String = ""
    
    var message = ""
    
    var alertType: AlertMessage = .unknowGender
    
    private var cancelables: Set<AnyCancellable> = []
    
    init(_ type: PersonType) {
        self.type = type
    }
    
    func actualizarListaPublisher(_ person: Person, _ type: PersonType) {
        provider.addPerson(person)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    self.message = error.localizedDescription
                    self.alertType = .failedRegister
                    self.activateMessage = true
                    break
                case .finished:
                    self.alertType = .succesful
                    self.activateMessage = true
                    break
                }
            } receiveValue: { (value) in
                self.message = value
            }
            .store(in: &cancelables)
    }
    
    func addPeople(type: PersonType, name: String, age: Int, gender: Gender){
        switch type {
        case .averageJoe:
            repository.uploadPerson(name, age, gender) {
                self.alertType = .succesful
                self.activateMessage = true
            } onFail: {
                self.alertType = .failedRegister
                self.activateMessage = true
            }
        case .student:
                  actualizarListaPublisher(Student(name: name,age: age, gender: gender), type)
        case .teacher:
                  actualizarListaPublisher(Teacher(name: name,age: age, gender: gender), type)
        case .parent:
                  actualizarListaPublisher(Parent(name: name,age: age, gender: gender), type)
        case .principal:
                  actualizarListaPublisher(Principal(name: name,age: age, gender: gender), type)
        }
    }
    
    func selectedEmoji(_ emoji: PersonType) -> String {
        switch emoji {
        case .student:
            return "👨🏽‍🎓👩🏼‍🎓"
        case .teacher:
            return "👩🏼‍🏫👨🏻‍🏫"
        case .parent:
            return "👨‍👧👩‍👦"
        case .principal:
            return "😎"
        default:
            return "🙎🏽‍♂️🙍🏼‍♀️"
        }
    }
    
    func add() {
                if  name != "" && age != ""{
                    if let opcional = Int(age){
                        
                        if otherText != "" && gender == .other("other"){
                            gender = .other(otherText)
                            }
                           addPeople(type: type, name: name, age: Int(opcional), gender: gender)
                        
                        if gender == .other(otherText){
                            otherText = ""
                            gender = .other("other")
                        }
                       
                    } else {
                        print("La edad es en numero")
                        alertType = .ageNumber
                        activateMessage = true
                    }
                } else {
                    print("No dejes campos vacios")
                    alertType = .emptyField
                    activateMessage = true
                }
    }
    
    func generateAlert(_ alertMessage: AlertMessage, _ presentationMode: Binding<PresentationMode>) -> Alert {
        var atention = Alert(title: Text("Message"), message: Text("Generic Alert"))
        
        switch alertMessage {
        case .ageNumber:
            atention = Alert(title: Text("Age is a number"), message: Text("Enter your age in number"))
        case .emptyField:
            atention = Alert(title: Text("Empty fields"), message: Text("Do not leave empty fields"))
        case .failedRegister:
            atention = Alert(title: Text("Failed 🙁"), message: Text("\(alertMessage.rawValue), \(message)"))
        case .succesful:
            atention = Alert(title: Text("Succes 😄"), message: Text(alertMessage.rawValue), primaryButton: Alert.Button.default(Text("Continue"), action: {
                presentationMode.wrappedValue.dismiss()
                print("Registro")
            }), secondaryButton: Alert.Button.cancel(Text("Stay Here")))
        case .unknowGender:
            atention = Alert(title: Text("Unknown Gender"), message: Text("Select some gender"))
        default:
            print("nil")
        break
        }
  
        return atention
    }
    
}

