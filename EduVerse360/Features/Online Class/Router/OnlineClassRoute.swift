//
//  OnlineClassRoute.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import Foundation

enum OnlineClassRoute: Hashable {
    case create
    case list
    case detail(id: Int)
    case update(id: Int)
}
