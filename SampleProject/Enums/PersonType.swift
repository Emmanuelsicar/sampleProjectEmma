//
//  PersonType.swift
//  SampleProject
//
//  Created by Ademar on 18/10/21.
//

import Foundation
import SwiftUI

enum PersonType: String, CaseIterable, Decodable{
    case student
    case teacher
    case parent
    case principal
    case averageJoe
    
    var icon: Image {
        switch self {
        case .student:
            return Image(systemName: "pencil")
        case .teacher:
            return Image(systemName: "pencil.circle")
        case .parent:
            return Image(systemName: "pencil.slash")
        case .principal:
            return Image(systemName: "pencil.tip.crop.circle")
        case .averageJoe:
            return Image(systemName: "person")
        }
    }
}
