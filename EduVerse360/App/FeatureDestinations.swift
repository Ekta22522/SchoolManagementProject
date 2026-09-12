//
//  FeatureDestinations.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import SwiftUI

struct FeatureDestinations: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: ClassRoute.self) { route in
                switch route {
                case .create:
                    ClassView()
                case .list:
                    AllClassesView()
                case .detail(let classID):
                    ClassByIdView(classId: classID)
                case .update(let classID):
                    UpdateClassView(classId: classID)
                }
            }
            .navigationDestination(for: SectionRoute.self) { route in
                switch route {
                case .list:
                    ListSectionView()
                case .create(let classID):
                    SectionView(classId: classID)
                case .classSections(let classID):
                    ClassSectionView(classId: classID)
                case .detail(let sectionID):
                    SectionByIdView(sectionId: sectionID)
                case .update(let sectionID):
                    UpdateSectionView(sectionId: sectionID)
                }
            }
            .navigationDestination(for: OnlineClassRoute.self) { route in
                switch route {
                case .create:
                    CreateOnlineClassView()
                case .list:
                    ListOnlineClassView()
                case .detail(let onlineClassID):
                    OnlineClassByIdView(onlineClassId: onlineClassID)
                case .update(let onlineClassID):
                    UpdateOnlineClassView(onlineClassId: onlineClassID)
                }
            }
            .navigationDestination(for: AssignmentRoute.self) { route in
                switch route {
                case .create:
                    CreateTeacherAssignmentView()
                case .detail(let assignmentID):
                    TeacherAssignmentByIdView(assignmentId: assignmentID)
                }
            }
            .navigationDestination(for: SharedRoute.self) { route in
                switch route {
                case .profile:
                    ProfileView()
                case .studentDetails(let studentID):
                    StudentDetailView(studentId: studentID)
                case .teacherDetails(let teacherID):
                    TeacherDetailView(teacherId: teacherID)
                }
            }
    }
}

extension View {
    func featureDestinations() -> some View {
        modifier(FeatureDestinations())
    }
}
