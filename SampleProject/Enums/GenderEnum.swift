//
//  GenderEnum.swift
//  SampleProject
//
//  Created by Ademar on 18/10/21.
//

import Foundation

enum Gender: CaseIterable, Hashable{
    static var allCases: [Gender] = [male, female, other("Other")]
    case male
    case female
    case other(String)
    
    var value: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .other(let string):
            return string
        }
    }
    
}
