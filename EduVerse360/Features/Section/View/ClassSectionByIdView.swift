//
//  SectionByIdView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 22/08/2026.
//

import SwiftUI

struct ClassSectionByIdView: View {
    let classId : String
    @State var viewModel = ClassSectionByIdViewModel()
    var body: some View {
        VStack(spacing:10){
            if let sections = viewModel.classSections{
                List(sections){section in
                    VStack{
                        Text("Id:\(section.id)")
                        Text("Class:\(section.classId)")
                        Text("Section Name:\(section.sectionName)")
                        Text("Class Teacher:\(section.classTeacher)")
                        Text("Capacity:\(section.capacity)")
                        Text("created At:\(section.createdAt)")
                        if let updatedAt = section.updatedAt{
                            Text("Updated At:\(updatedAt)")
                        }
                        if let className = section.className{
                            Text("Class Name:\(className)")
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.classSection(id: classId)
        }
        
    }
}

#Preview {
    ClassSectionByIdView(classId: "")
}
