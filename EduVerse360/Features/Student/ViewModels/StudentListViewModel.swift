//
//  StudentListViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 27/07/2026.
//
import Foundation
import Observation
@Observable
class StudentListViewModel{
    var students :[UserModel] = []
    var searchText = ""
        
    
   private let studentService : StudentMockAPI
    
    init(studentService: StudentMockAPI) {
        self.studentService = studentService
       
        }
    
    func searchStudent()async{
        do{
            students = try await studentService.searchStudent(searchText:searchText)
        }catch{
           print (error)
        }
    }
    
    
    func loadStudents() async{
        do{
            students = try await studentService.getStudents()
        }catch{
           print (error)
        }
//            students = [ // this array for just to show student in list in studentListView
//                UserModel(id: 1,
//                          firstName: "Ekta",
//                          lastName: "Rai",
//                          userName: "ekta@gmail.com",
//                          password: "12345678",
//                          role: "student"),
//
//                UserModel(id: 2,
//                          firstName: "Aarav",
//                          lastName: "Sharma",
//                          userName: "aarav@gmail.com",
//                          password: "12345678",
//                          role: "student"),
//
//                UserModel(id: 3,
//                          firstName: "Sita",
//                          lastName: "Thapa",
//                          userName: "sita@gmail.com",
//                          password: "12345678",
//                          role: "student")
//            ]
        
        
        }
    
}
