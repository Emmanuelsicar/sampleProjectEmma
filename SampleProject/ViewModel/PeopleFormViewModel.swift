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
        var newPeople: Person
        switch type {
        case .averageJoe:
                  newPeople = RegularPerson(name: name,age: age, gender: gender)
        case .student:
                  newPeople = Student(name: name,age: age, gender: gender)
        case .teacher:
                  newPeople = Teacher(name: name,age: age, gender: gender)
        case .parent:
                  newPeople = Parent(name: name,age: age, gender: gender)
        case .principal:
                  newPeople = Principal(name: name,age: age, gender: gender)
        }
        actualizarListaPublisher(newPeople, type)
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
    
    func upLoadAveragePerson(_ name: String, _ age: Int, _ gender: Gender){
       let person = RegularPerson(name: name, age: age, gender: gender)
        if let opcional1 = person.age, let opcional2 = person.gender{
            guard let url = URL(string: "https://urlrequest.000webhostapp.com/register.php?id=\(person.id)&name=\(person.name)&age=\(opcional1)&gender=\(opcional2.value)&pType=\(person.pType.rawValue)") else {return}
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
                        self.message = error.localizedDescription
                        self.alertType = .failedRegister
                        self.activateMessage = true
                        break
                    case .finished:
                        self.alertType = .succesful
                        self.activateMessage = true
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
    
    func add() {
                if  name != "" && age != ""{
                    if let opcional = Int(age){
                        
                        if otherText != "" && gender == .other("other"){
                            gender = .other(otherText)
                            }
                        if type == .averageJoe{
                            upLoadAveragePerson(name, Int(opcional), gender)
                        }else{
                            addPeople(type: type, name: name, age: Int(opcional), gender: gender)
                        }
  
                        
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

