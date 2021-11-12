//
//  StudentRowView.swift
//  SampleProject
//
//  Created by SICAR on 18/10/21.
//

import Foundation
import SwiftUI

struct StudentRowView: View {
    
    //let student: Student
    
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
            Text("\(person.extraInfo())")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}
