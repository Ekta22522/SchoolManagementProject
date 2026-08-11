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
    
    
    private let teacherService : TeacherMockAPI
    
    init(teacherService: TeacherMockAPI) {
        self.teacherService = teacherService
        
    }
    
    
    func searchTeachers() async {
        do{
            teachers = try await teacherService.searchTeachers(searchText: searchText)
        }catch{
            print (error)
        }
    }
    
    func loadTeachers() async{
        do{
            teachers = try await teacherService.getTeachers()
        }catch{
            print (error)
        }
    }
}
