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
    @State private var hasAppeared = false

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

                    // MARK: Stats
                    HStack(spacing: 12) {
                        StatCard(title: "Total", count: viewModel.totalCount, accentColor: Color.primary)
                        StatCard(title: "Published", count: viewModel.publishedCount, accentColor: Color.teal)
                        StatCard(title: "Pending", count: viewModel.pendingCount, accentColor: Color.orange)
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
            await viewModel.allTeacherAssignment()
        }
        // Refetch on every reappear so the dashboard is not stale
        // after creating/updating/deleting an assignment.
        .onAppear {
            if hasAppeared {
                Task {
                    await viewModel.allTeacherAssignment()
                }
            }
            hasAppeared = true
        }
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
