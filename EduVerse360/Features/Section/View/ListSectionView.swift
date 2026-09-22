//
//  ListSectionView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 22/08/2026.
//

import SwiftUI

private struct SectionCardRow: View {

    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {

        Button {
            action()
        } label: {
            HStack(spacing: 12) {

                VStack(alignment: .leading, spacing: 6) {

                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primary)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
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
        .buttonStyle(.plain)

    }
}

struct ListSectionView: View {

    @State var viewModel = ListSectionViewModel()

    @Environment(TabRouter.self) private var router

    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Header

                HStack {
                    Text("All Sections")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 15)

                // MARK: Content

                if let errorMessage = viewModel.errorMessage, viewModel.listSection == nil {

                    Text(errorMessage)
                        .foregroundStyle(Color.secondaryText)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if let sections = viewModel.listSection {

                    if sections.isEmpty {

                        VStack(spacing: 12) {
                            Image(systemName: "rectangle.split.3x1")
                                .font(.system(size: 40))
                                .foregroundStyle(.secondary)

                            Text("No sections yet")
                                .font(.headline)
                                .fontWeight(.semibold)

                            Text("Sections will appear here once they are created.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal, 30)

                    } else {

                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(sections) { section in
                                    SectionCardRow(
                                        title: section.sectionName,
                                        subtitle: subtitle(for: section),
                                        action: {
                                            router.push(SectionRoute.detail(id: section.id))
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                } else {

                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                }
            }
        }
        .onAppear {
            Task {
                await viewModel.getAllSection()
            }
        }
    }

    private func subtitle(for section: Section) -> String {
        var parts: [String] = []
        if let className = section.className {
            parts.append(className)
        }
        parts.append("Teacher: \(section.classTeacher)")
        parts.append("Capacity: \(section.capacity)")
        return parts.joined(separator: " · ")
    }
}

#Preview {
    ListSectionView()
        .environment(TabRouter())
}
