//
//  StudentRoute.swift
//  EduVerse360
//
//  Created by Ekta Rai on 21/09/2026.
//

import Foundation

enum StudentRoute: Hashable {
    case create
    case studentById(id: Int)
    case update(student: Student)
}
