//
//  UpdateStudentViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 21/09/2026.
//

import Foundation
import Observation

@Observable
class UpdateStudentViewModel{
    var student : Student?
    var userId = 0
    var admissionNumber = ""
    var enrollmentYear = 0
    var major = ""
    var dateOfBirth = ""
    var gender = ""
    var address = ""
    var guardianName = ""
    var guardianPhone = ""
    var status = ""
    var isAlumni = false
    var isLoading = false
    var isSuccess = false
    var errorMessage : String?
    
    private var updateStudentService : StudentProtocol
    init(updatestudentservice : StudentProtocol = StudentServerAPI()){
        self.updateStudentService = updatestudentservice
    }
    
    func putStudent(req: UpdateStudentReq,id:Int) async{
        isLoading = true
        errorMessage = nil
        print("Student Updating process is started")

        defer{
            isLoading = false
            print("Student Updating process is ended")
        }
        
        do{
            let request = UpdateStudentReq(userId: userId, admissionNumber: admissionNumber, enrollmentYear: enrollmentYear, major: major, dateOfBirth: dateOfBirth, gender: gender, address: address, guardianName: guardianName, guardianPhone: guardianPhone, status: status, isAlumni: isAlumni)
            let response : UpdateStudentRes = try await self.updateStudentService.updateStudent(req: request, id: id)
            student = response.student
            isSuccess = true
            print("Student Updated Successfully")
        }catch{
            errorMessage = error.localizedDescription
        }
    }
}
