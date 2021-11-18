//
//  PeopleFormView.swift
//  SampleProject
//
//  Created by SICAR on 27/10/21.
//

import SwiftUI

struct PeopleFormView: View {
    
    @ObservedObject var viewModel: PeopleFormViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Register")){
                HStack {
                    Text("Register \(viewModel.type.rawValue) \(viewModel.selectedEmoji(viewModel.type))")
                        .bold()
                }
            }
            
            Section(header: Text("Form Info")){
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
                    if viewModel.gender == .other("Other"){
                        VStack {
                            Text("If you wish, specify your gender")
                                .italic()
                            TextField("Write your gender", text: $viewModel.otherText)
                        }
                    }
                }
                .padding()
            }
    
            Section(header: Text("Submit")){
                Button {
                    viewModel.add()
                } label: {
                    HStack {
                        Text("Add \(viewModel.type.valueName)")
                        Spacer()
                        viewModel.type.icon
                    }
                    .alert(isPresented: $viewModel.activateMessage, content: {
                        viewModel.generateAlert(viewModel.alertType, presentationMode)
                    })
                }
            }
        }
        
    }
}



struct PeopleFormView_Previews: PreviewProvider {
    static var view: PeopleFormViewModel = .init(.principal)
    
    static var previews: some View {
        PeopleFormView(viewModel: view)
    }
}
