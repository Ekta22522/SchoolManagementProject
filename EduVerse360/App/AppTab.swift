//
//  AppTab.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import SwiftUI

enum AppTab: String, Hashable {
    case home
    case work
    case classes
    case students
    case teachers
    case settings

    var title: String {
        switch self {
        case .home: return "Home"
        case .work: return "Work"
        case .classes: return "Classes"
        case .students: return "Students"
        case .teachers: return "Teachers"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house"
        case .work: return "text.document"
        case .classes: return "applepencil.tip"
        case .students: return "graduationcap.fill"
        case .teachers: return "person.3"
        case .settings: return "gearshape"
        }
    }

    @ViewBuilder
    func rootView(role: UserRole) -> some View {
        switch self {
        case .home:
            HomeView()
        case .work:
            switch role {
            case .teacher:
                AllTeacherAssignmentView()
            default:
                TeacherOnlyView()
            }
        case .classes:
            switch role {
            case .teacher:
                ListOnlineClassView()
            default:
                AllClassesView()
            }
        case .students:
            StudentsListView()
        case .teachers:
            TeachersListView()
        case .settings:
            SettingsView()
        }
    }

    static func tabs(for role: UserRole) -> [AppTab] {
        switch role {
        case .schoolAdmin, .superAdmin:
            return [.home, .work, .students, .classes, .teachers, .settings]
        case .teacher:
            return [.home, .work, .classes, .settings]
        case .student:
            return [.home, .classes, .settings]
        }
    }
}
