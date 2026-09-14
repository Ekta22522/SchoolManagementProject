//
//  TabRouter.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import Foundation
import SwiftUI
import Observation

@Observable
final class TabRouter {
    var selection: AppTab = .home
    private(set) var paths: [AppTab: NavigationPath] = [:]

    func binding(for tab: AppTab) -> Binding<NavigationPath> {
        Binding(
            get: { self.paths[tab] ?? NavigationPath() },
            set: { self.paths[tab] = $0 }
        )
    }

    func push<V: Hashable>(_ value: V) {
        paths[selection, default: NavigationPath()].append(value)
    }

    func pop() {
        paths[selection]?.removeLast()
    }

    func popToRoot() {
        paths[selection] = NavigationPath()
    }

    func reset() {
        paths = [:]
        selection = .home
    }
}
