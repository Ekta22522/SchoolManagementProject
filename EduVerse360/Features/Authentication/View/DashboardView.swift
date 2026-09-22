//
//  DashboardView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 16/09/2026.
//

import SwiftUI

struct DashboardView: View {
    @Environment(TabRouter.self) private var router
    @Environment(UserSession.self) private var session

    @State private var viewModel = AllTeacherAssignmentViewModel()
    @State private var onlineClassViewModel = ListOnlineClassViewModel()
    @State private var classesViewModel = AllClassesViewModel()
    @State private var studentsViewModel = StudentListViewModel()
    @State private var teachersViewModel = TeachersListViewModel(teacherService: TeacherMockAPI())
    @State private var hasAppeared = false

    private var isTeacher: Bool {
        session.activeRole == .teacher
    }

    private var isAdmin: Bool {
        session.activeRole == .schoolAdmin || session.activeRole == .superAdmin
    }

    private var teacherFilterId: Int? {
        isTeacher ? session.user?.id : nil
    }

    private var upcomingOnlineClasses: [OnlineClass] {
        Array(
            (onlineClassViewModel.onlineClass ?? [])
                .sorted { scheduledDate($0.scheduledAt) < scheduledDate($1.scheduledAt) }
                .prefix(3)
        )
    }

    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Dashboard")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            if let username = session.user?.username {
                                Text("Welcome back, \(username)")
                                    .foregroundStyle(Color.secondaryText)
                            }
                        }
                        Spacer()

                        Button(action: {
                            router.push(AssignmentRoute.create)
                        }, label: {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: 50, maxHeight: 50)
                                .background(Color.primary)
                                .clipShape(Circle())
                                .shadow(radius: 10, y: 2)
                        })
                    }

                    // MARK: Assignment Stats
                    HStack(spacing: 12) {
                        StatCard(title: "Total", count: viewModel.totalCount, accentColor: Color.primary)
                        StatCard(title: "Published", count: viewModel.publishedCount, accentColor: Color.teal)
                        StatCard(title: "Pending", count: viewModel.pendingCount, accentColor: Color.orange)
                    }

                    // MARK: Overview Stats
                    if isTeacher {
                        HStack(spacing: 12) {
                            StatCard(title: "My online classes", count: onlineClassViewModel.onlineClass?.count ?? 0, accentColor: Color.primary)
                        }
                    } else if isAdmin {
                        HStack(spacing: 12) {
                            StatCard(title: "Classes", count: classesViewModel.classes.count, accentColor: Color.primary)
                            StatCard(title: "Students", count: studentsViewModel.students.count, accentColor: Color.teal)
                            StatCard(title: "Teachers", count: teachersViewModel.teachers.count, accentColor: Color.orange)
                        }
                    }

                    // MARK: Upcoming online classes
                    HStack {
                        Text("Upcoming online classes")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        // Admins have no online classes list to jump to —
                        // their Classes tab shows school classes instead.
                        if !isAdmin {
                            Button("View all") {
                                router.selection = .classes
                            }
                            .foregroundStyle(Color.primary)
                        }
                    }

                    if upcomingOnlineClasses.isEmpty {
                        Text("No upcoming online classes.")
                            .foregroundStyle(Color.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ForEach(upcomingOnlineClasses) { onlineClass in
                            UpcomingClassCard(onlineClass: onlineClass)
                                .onTapGesture {
                                    router.push(OnlineClassRoute.detail(id: onlineClass.id))
                                }
                        }
                    }

                    // MARK: Recent assignments
                    HStack {
                        Text("Recent assignments")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Button("View all") {
                            router.selection = .work
                        }
                        .foregroundStyle(Color.primary)
                    }

                    if viewModel.isLoading && viewModel.totalCount == 0 {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else if let errorMessage = viewModel.errorMessage, viewModel.totalCount == 0 {
                        Text(errorMessage)
                            .foregroundStyle(Color.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else if viewModel.totalCount == 0 {
                        Text("No assignments yet. Tap + to create your first assignment.")
                            .foregroundStyle(Color.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ForEach(viewModel.recentAssignments) { assignment in
                            AssignmentCard(assignment: assignment, viewPdfAction: {
                                viewModel.showAssignmentPdf = true
                                print("View PDF: \(assignment.title)")
                            })
                            .onTapGesture {
                                router.push(AssignmentRoute.detail(id: assignment.id))
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $viewModel.showAssignmentPdf) {
            PDFScreen(pdfURL: "https://www.ioactive.com/wp-content/uploads/pdfs/IOActive_Remote_Car_Hacking.pdf")
        }
        .task {
            await fetchAllData()
        }
        // Refetch on every reappear so the dashboard is not stale
        // after creating/updating/deleting an assignment.
        .onAppear {
            if hasAppeared {
                Task {
                    await fetchAllData()
                }
            }
            hasAppeared = true
        }
    }

    private func fetchAllData() async {
        await viewModel.allTeacherAssignment(teacherId: teacherFilterId)
        await onlineClassViewModel.getListOnlineClass(teacherId: teacherFilterId)
        if isAdmin {
            await classesViewModel.getAllClasses()
            await studentsViewModel.ListStudent()
            await teachersViewModel.loadTeachers()
        }
    }

    private func scheduledDate(_ scheduledAt: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: scheduledAt) {
            return date
        }
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: scheduledAt) ?? .distantFuture
    }
}

private struct StatCard: View {
    let title: String
    let count: Int
    let accentColor: Color

    var body: some View {
        VStack(spacing: 6) {
            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(accentColor)
            Text(title)
                .font(.caption)
                .foregroundStyle(Color.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

private struct UpcomingClassCard: View {
    let onlineClass: OnlineClass

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(onlineClass.title ?? "Untitled class")
                    .font(.headline)
                    .fontWeight(.bold)

                Text("\(onlineClass.className) · \(onlineClass.subject)")
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryText)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(scheduledText)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primary)

                Text(timeText)
                    .font(.caption)
                    .foregroundStyle(Color.tertiaryText)
            }

            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(Color.tertiaryText)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
    }

    private var scheduledText: String {
        guard let date = date else { return "TBD" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private var timeText: String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private var date: Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: onlineClass.scheduledAt) {
            return date
        }
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: onlineClass.scheduledAt)
    }
}
