//
//  MainTabView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 14/07/2026.
//

import SwiftUI

struct MainTabView: View {

    @Environment(TabRouter.self) private var tabRouter
    @Environment(UserSession.self) private var session

    var body: some View {
        TabView(selection: Binding(
            get: { tabRouter.selection },
            set: { tabRouter.selection = $0 }
        )) {
            ForEach(AppTab.tabs(for: session.activeRole), id: \.self) { tab in
                NavigationStack(path: tabRouter.binding(for: tab)) {
                    tab.rootView(role: session.activeRole)
                        .featureDestinations()
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .tag(tab)
            }
        }
    }
}
