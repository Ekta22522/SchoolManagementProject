//
//  Untitled.swift
//  EduVerse360
//
//  Created by Ekta Rai on 20/08/2026.
//

class SectionServerAPI : SectionProtocol{
    
    func createSection(req: SectionReq,id:String) async throws -> SectionRes {
        do{
            let sectionRes : SectionRes = try await APIClient.shared.request(APIEndpoint.createSection(id: id), body: req)
            return sectionRes
            
        }catch let error{
           throw error
        }
        
    }
    
    func listSection() async throws -> ListSectionRes  {
        do{
            let listSectionRes:ListSectionRes = try await APIClient.shared.request(APIEndpoint.allSection)
            return listSectionRes
        }catch let error{
            throw error
        }
    }
    
    func getClassSectionById(id:String) async throws -> ClassSectionByIdRes {
        do{
            let response : ClassSectionByIdRes = try await APIClient.shared.request(APIEndpoint.classSectionById(id:id))
            return response
        }catch let error{
            throw error
        }
    }
    
    func getSectionById(id: Int) async throws -> SectionById {
        do{
            let response : SectionById = try await APIClient.shared.request(APIEndpoint.sectionById(id: id))
            return response
        }catch let error{
            throw error
        }
    }
    
    func getUpdateSection(id: Int, req: UpdateSectionReq) async throws -> UpdateSectionRes {
        do{
            let response:UpdateSectionRes = try await APIClient.shared.request(APIEndpoint.updateSection(id: id), body: req)
            return response
        }catch let error{
            throw error
        }
    }
    
    func getDeleteSec(id: Int) async throws -> DeleteSecRes {
        do{
            let response : DeleteSecRes = try await APIClient.shared.request(APIEndpoint.deleteSection(id: id))
            return response
            
        }catch let error{
            throw error
        }
    }
}
