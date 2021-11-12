//
//  ContentView.swift
//  SampleProject
//
//  Created by Ademar on 18/10/21.
//

import SwiftUI

struct MainAppView: View {
    
    @StateObject var viewModel: MainAppViewModel = MainAppViewModel()
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Add Person")) {
                    ForEach(PersonType.allCases, id: \.self) { pType in
                        if pType != .averageJoe{
                            NavigationLink(destination: PeopleFormView(viewModel: PeopleFormViewModel(pType))){
                                HStack {
                                    Text("\(pType.rawValue)")
                                    Spacer()
                                    pType.icon
                                }
                            }
                        } else{
                         
                            NavigationLink(destination: PeopleFormView(viewModel: PeopleFormViewModel(pType))){
                                HStack {
                                    Text("Upload Average Person")
                                    Spacer()
                                    pType.icon
                                }
                            }
                            
                            Button {
                                viewModel.downloadPerson()
                            } label: {
                                HStack {
                                    Text("\(pType.rawValue)")
                                    Spacer()
                                    pType.icon
                                }
                                .alert(isPresented: $viewModel.alertMessage, content: {
                                    viewModel.generateAlert(viewModel.alertType)
                                })
                            }
                            
                        }
                        
                    }
                }
                
                Section(header: Text("Filter")) {
                    HStack {
                        TextField("Search", text: $viewModel.filterText).onChange(of: viewModel.filterText, perform: { value in
                            viewModel.updateList()
                        })
                        Button {
                            viewModel.updateList()
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
                
                Section(header: Text("Order")) {
                    Picker("Order factor:", selection: $viewModel.selectedFactor) {
                        ForEach(OrderFactor.allCases, id: \.self) { order in
                            Text("\(order.rawValue)")
                        }
                    }
                    
                    Picker("Order by:", selection: $viewModel.selectedOrder) {
                        ForEach(ReturnOrder.allCases, id: \.self) { order in
                            Text("\(order.rawValue)")
                        }
                    }
                }
                
                    
                Section(header: Text("People")) {
                    Button {
                        viewModel.clearAll()
                    } label: {
                        HStack{
                            Text("Clear All")
                        }
                    }
                    .alert(isPresented: $viewModel.alertMessage, content: {
                        viewModel.generateAlert(viewModel.alertType)
                    })
                    
                    ForEach(viewModel.peopleList, id: \.id) { person in
                
                        if person.pType != PersonType.averageJoe {
                            NavigationLink(destination:  EditPeopleFormView(viewModel: EditPeopleFormViewModel(person))){
                                                           PersonRowView(person: person)
                             }
                        } else {
                            PersonRowView(person: person)
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.deletePerson(at: indexSet)
                    }
                }
                
                       
            }
            
            .navigationTitle("People List")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.fillRandomly()
                    } label: {
                        Image(systemName: "lasso.sparkles")
                    }
                    EditButton()
                }
            }
            .onAppear {
                viewModel.updateList()
            }
            
        }
        
    }
}

private struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
    }
}
