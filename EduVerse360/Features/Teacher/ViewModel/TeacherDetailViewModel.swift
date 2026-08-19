//
//  TeacherDetailViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 28/07/2026.
//

import Foundation
import Observation
@Observable

class TeacherDetailViewModel{
    
 let teacherService : TeacherProtocol
    
    var teacher : UserModel?
    
    init(teacherService: TeacherProtocol) {
        self.teacherService = teacherService
    }
    
   
    
    func loadTeacherDetail(by id: Int)async{
        
        do{
            teacher = try await teacherService.getTeachers(by: id)
        }catch let error{
            
        }
        
    }
}


