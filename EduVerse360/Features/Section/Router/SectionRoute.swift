//
//  SectionRoute.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import Foundation

enum SectionRoute: Hashable {
    case list
    case create(classId: String)
    case classSections(classId: String)
    case detail(id: Int)
    case update(id: Int)
}
