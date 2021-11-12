//
//  AlertMessage.swift
//  SampleProject
//
//  Created by SICAR on 04/11/21.
//

import Foundation

enum AlertMessage: String, CaseIterable {
    case emptyField = "Do not leave empty fields"
    case ageNumber  = "Enter your age in number"
    case unknowGender = "Select some gender"
    case succesful = "Continue"
    case failedRegister = "Failed"
    case deleteAll = "Are you sure you delete all people?"
}
