//
//  EditPeopleFormView.swift
//  SampleProject
//
//  Created by SICAR on 02/11/21.
//

import SwiftUI

struct EditPeopleFormView: View {
    
    @ObservedObject var viewModel: EditPeopleFormViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form{
            HStack {
                Text("Edit \(viewModel.person.name)")
                    .bold()
            }
            .padding()
                VStack {
                    Text("Full Name")
                    Divider()
                    TextField("Write the name", text: $viewModel.name)
                    Text("Age")
                    Divider()
                    TextField("Write the age", text: $viewModel.age)
                }
                .padding()
                VStack {
                    Text("Gender")
                    Divider()
                    Picker("Select Gender:", selection: $viewModel.gender) {
                        ForEach(Gender.allCases, id: \.self) { order in
                            Text("\(order.value)")
                        }
                    }
                    if viewModel.gender == .other("other"){
                        VStack {
                            Text("If you wish, specify your gender")
                                .italic()
                            TextField("Write your gender", text: $viewModel.otherText)
                        }
                    }
        }
                .padding()
            Button {
                viewModel.edite()
            } label: {
                HStack {
                    Text("Edit \(viewModel.person.pType.rawValue)")
                    Spacer()
                    viewModel.person.pType.icon
                }
            }
            .alert(isPresented: $viewModel.activateMessage, content: {
                viewModel.generateAlert(viewModel.alertType, presentationMode)
            })
    }
  }
}

struct EditPeopleFormView_Previews: PreviewProvider {
    static var previews: some View {
        EditPeopleFormView(viewModel: EditPeopleFormViewModel(Principal(name: "Puerco", age: 20, gender: .other("Cerdo"))))
    }
}
