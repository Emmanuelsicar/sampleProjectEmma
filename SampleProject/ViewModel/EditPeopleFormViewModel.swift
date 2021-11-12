//
//  EditPeopleFormViewModel.swift
//  SampleProject
//
//  Created by SICAR on 04/11/21.
//

import Foundation
import Combine
import SwiftUI

class EditPeopleFormViewModel: ObservableObject {
    
    var person: Person
    
    let provider: PeopleProvider = PeopleProvider.shared
    
    @Published var activateMessage: Bool = false
    
    @Published var name: String = ""
    
    @Published var age: String = ""
    
    @Published var gender: Gender = .male
    
    @Published var otherText: String = ""
    
    var message = ""
    
    var alertType: AlertMessage = .unknowGender
    
    private var cancelables: Set<AnyCancellable> = []
    
    init(_ person: Person) {
        self.person = person
        self.name = person.name
        
        var number: Int
        
        if let enteroOpcional = person.age{
            number = enteroOpcional
            age = "\(number)"
        }
        
        if let opcionalGenero = person.gender{
            if opcionalGenero != .female && opcionalGenero != .male && opcionalGenero != .other("other"){
                self.gender = .other("other")
                self.otherText = opcionalGenero.value
            }else{
                self.gender = opcionalGenero
            }
        }
       
    }
    
    func editPeople(person: Person, name: String, age: Int, gender: Gender){
        var editPerson = person
        editPerson.name = name
        editPerson.age = age
        editPerson.gender = gender
        
        provider.editPerson(editPerson)
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
    
    func edite(){
        if  name != "" && age != ""{
            if let opcional = Int(age){
                
                if otherText != "" && gender == .other("other"){
                    gender = .other(otherText)
                    }
                editPeople(person: person, name: name, age: opcional, gender: gender)
                
                if gender == .other(otherText){
                    otherText = ""
                    gender = .other("other")
                }
               
            } else {
                print("La edad es en numero")
                alertType = .ageNumber
                self.activateMessage = true
            }
        } else {
            print("No dejes campos vacios")
            self.alertType = .emptyField
            self.activateMessage = true
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
            atention = Alert(title: Text("Failed 🙁"), message: Text(alertMessage.rawValue))
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
