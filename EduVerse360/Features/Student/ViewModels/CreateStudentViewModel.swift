//
//  CreateStudentViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 21/09/2026.
//

import Foundation
import Observation

@Observable
class CreateStudentViewModel{
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
    var createdAt = ""
    var updatedAt = ""
    var isLoading = false
    var isSuccess = false
    var errorMessage : String?
     
    private var createStudentService : StudentProtocol
    
    init(createstudentservice : StudentProtocol = StudentServerAPI()){
        self.createStudentService = createstudentservice
    }
    
    func postStudent () async {
        do{
            isLoading = true
            print("Create Student is Started")
            defer{
                isLoading = false
                print("Create Student is ended")
            }
            let request = CreateStudentReq(userId: userId, admissionNumber: admissionNumber, enrollmentYear: enrollmentYear, major: major, dateOfBirth: dateOfBirth, gender: gender, address: address, guardianName: guardianName, guardianPhone: guardianPhone, status: status, isAlumni: isAlumni, createdAt: createdAt.isEmpty ? nil : createdAt, updatedAt: updatedAt.isEmpty ? nil : updatedAt)
            let response : CreateStudentRes = try await self.createStudentService.createStudent(req:request)
            isSuccess = true
            print("Student Created Succesfully")
        }catch{
            errorMessage = error.localizedDescription
        }
    }
}
