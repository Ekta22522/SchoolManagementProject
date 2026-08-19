//
//  ClassServerAPI.swift
//  EduVerse360
//
//  Created by Ekta Rai on 17/08/2026.
//

import Foundation

class ClassServerAPI : ClassProtocol{
    func getClass(req: ClassReq) async throws -> ClassRes {
        do{
            let classRes: ClassRes = try await APIClient.shared.request(APIEndpoint.classes, body: req)
            return classRes
        }catch let error{
            throw error
        }
    }
    
    
    func getAllClasses() async throws -> AllclassesRes {
        do{
            let allClassesRes : AllclassesRes = try await APIClient.shared.request(APIEndpoint.allClasses)
            return allClassesRes
        } catch let error {
            throw error
        }
    }
    
    func getClassByID(id: String) async throws -> ClassByIDRes {
        do{
            let classByIDRes : ClassByIDRes = try await APIClient.shared.request(APIEndpoint.classByID(id: id))
            return classByIDRes
            
        }catch let error{
           throw error
        }
    }
    
    func updateClass(id: String) async throws -> UpdateClassRes {
        do{
            let updateClassRes : UpdateClassRes = try await APIClient.shared.request(APIEndpoint.updateClass(id: id))
            return updateClassRes
        }catch let error{
            throw error
        }
    }
    
    
}
