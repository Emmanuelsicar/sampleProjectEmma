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
            HStack {
                Text("Register \(viewModel.type.rawValue) \(viewModel.selectedEmoji(viewModel.type))")
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
                viewModel.add()
            } label: {
                HStack {
                    Text("Add \(viewModel.type.rawValue)")
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



struct PeopleFormView_Previews: PreviewProvider {
    static var view: PeopleFormViewModel = .init(.principal)
    
    static var previews: some View {
        Group {
            PeopleFormView(viewModel: view)
                .previewDevice("iPad Air (4th generation)")
            PeopleFormView(viewModel: view)
                .previewDevice("iPhone 11")
            PeopleFormView(viewModel: view)
        }
    }
}
