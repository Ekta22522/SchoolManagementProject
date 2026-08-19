//
//  StudentDetailsView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 28/07/2026.
//
import Foundation
import Observation

@Observable
class StudentDetailsViewModel{
    
    let studentService: StudentProtocol
    
    var student: UserModel?
    
    init(studentService: StudentProtocol) {
        self.studentService = studentService
    }
    
    
    func loadStudentDetail(by id: Int) async {
        
        
        do {
            student = try await studentService.getStudent(by: id)
        
        } catch let error {
            
        }
        
        
       
    }
    
    
}

