//
//  PersonRowView.swift
//  SampleProject
//
//  Created by Ademar on 18/10/21.
//

import SwiftUI

struct PersonRowView: View {
    
    let person: Person
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(person.id)")
                .font(.footnote)
                .foregroundColor(.gray)
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 5) {
                    Text("\(person.name)")
                        .font(.headline)
                }
                HStack(spacing: 5) {
                    
                    VStack(alignment: .leading,spacing: 5) {
                        if let age = person.age {
                            Text("age: \(age)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        if let gender = person.gender {
                            Text("gender: \(gender.value)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                    person.pType.icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            }
            HStack{
                Text("\(person.extraInfo())")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Spacer()
                Text("Type: \(person.pType.rawValue)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct PersonRowView_Previews: PreviewProvider {
    static var previews: some View {
        PersonRowView(person: Student(name: "Mane", age: 25, gender: .male))
    }
}
