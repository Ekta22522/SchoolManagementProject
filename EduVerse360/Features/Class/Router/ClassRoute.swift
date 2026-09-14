//
//  ClassRoute.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import Foundation

enum ClassRoute: Hashable {
    case create
    case list
    case detail(id: String)
    case update(id: String)
}
