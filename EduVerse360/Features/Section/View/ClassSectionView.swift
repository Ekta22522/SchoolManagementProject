//
//  SectionByIdView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 22/08/2026.
//

import SwiftUI

struct ClassSectionView: View {
    let classId : String
   
    @State var viewModel = ClassSectionViewModel()
    var body: some View {
        VStack(spacing:10){
            VStack{
                if let classRoom = viewModel.classRoom{
                    VStack{
                        Text(" Class id:\(classRoom.id)")
                        Text("Class Name:\(classRoom.className)")
                        Text("Description:\(classRoom.description)")
                        Text("Created At:\(classRoom.createdAt)")
                        Text("Updated At:\(classRoom.updatedAt)")
                    }
                }
            }
            if let sections = viewModel.section{
                List(sections){section in
                    VStack{
                        Text("Id:\(section.id)")
                        Text("Class Id:\(section.classId)")
                        Text("Section Name:\(section.sectionName)")
                        Text("Class Teacher:\(section.classTeacher)")
                        Text("Capacity:\(section.capacity)")
                        Text("created At:\(section.createdAt)")
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
    ClassSectionView(classId: "")
}
