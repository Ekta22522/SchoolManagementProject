//
//  AdminWorkView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 22/09/2026.
//

import SwiftUI

struct AdminWorkView: View {

    private enum WorkSegment: String, CaseIterable {
        case assignments = "Assignments"
        case onlineClasses = "Online Classes"
    }

    @State private var segment: WorkSegment = .assignments

    var body: some View {
        VStack(spacing: 0) {
            Picker("Work", selection: $segment) {
                ForEach(WorkSegment.allCases, id: \.self) { segment in
                    Text(segment.rawValue).tag(segment)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.pageBackground)

            switch segment {
            case .assignments:
                AllTeacherAssignmentView()
            case .onlineClasses:
                ListOnlineClassView()
            }
        }
        .background(Color.pageBackground)
    }
}

#Preview {
    AdminWorkView()
        .environment(UserSession())
        .environment(TabRouter())
}
