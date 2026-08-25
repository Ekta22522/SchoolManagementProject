//
//  SectionByIdView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 24/08/2026.
//

import SwiftUI

struct SectionByIdView: View {
    @Environment(NavigationRouter.self) private var router
    @State var viewModel = SectionByIdViewModel()
   
    var sectionId : Int
    var body: some View {
        VStack{
            VStack{
                if let section = viewModel.section{
                    Text("Section Id:\(section.id)")
                    Text("Class Id:\(section.classId)")
                    if let classname = section.className{
                        Text("Class Name:\(classname)")
                    }
                    Text("Section Name:\(section.sectionName)")
                    Text("Class Teacher:\(section.classTeacher)")
                    Text("Capacity:\(section.capacity)")
                    Text("Created At:\(section.createdAt)")
                }
            }
            .foregroundColor(Color.white)
            .background(Color.primary)
            .cornerRadius(20)
            .shadow(radius: 10)
            HStack{
                Button(action:{
                    router.goToUpdateSection(id: sectionId)
                },label:{
                    Text("Update")
                        .foregroundStyle(.white)
                })
                .frame(maxWidth:100, maxHeight: 50)
                .background(Color.primary)
                .cornerRadius(10)
                
                Button(action:{
                    router.goToDeleteSection(id: sectionId)
                },label:{
                    Text("Delete")
                        .foregroundStyle(.white)
                })
                .frame(maxWidth:100, maxHeight: 50)
                .background(Color.primary)
                .cornerRadius(10)
            }
    }
        .task {
            await viewModel.section(id: sectionId)
        }
    }
}

#Preview {
    SectionByIdView(sectionId:1)
}
