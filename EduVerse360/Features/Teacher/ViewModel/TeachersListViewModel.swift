//
//  TeachersListViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 27/07/2026.
//

import Foundation
import Observation


@Observable
class TeachersListViewModel{
    
    
    
    var searchText = ""

    var teachers :[UserModel] = []

    var errorMessage : String?


    private let teacherService : TeacherMockAPI

    init(teacherService: TeacherMockAPI) {
        self.teacherService = teacherService

    }


    func searchTeachers() async {
        errorMessage = nil
        do{
            teachers = try await teacherService.searchTeachers(searchText: searchText)
        }catch{
            errorMessage = error.localizedDescription
            print (error)
        }
    }

    func loadTeachers() async{
        errorMessage = nil
        do{
            teachers = try await teacherService.getTeachers()
        }catch{
            errorMessage = error.localizedDescription
            print (error)
        }
    }
}
