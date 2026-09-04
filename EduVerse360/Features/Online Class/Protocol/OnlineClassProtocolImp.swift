//
//  OnlineClassProtocolImp.swift
//  EduVerse360
//
//  Created by Ekta Rai on 31/08/2026.
//
class OnlineClassProtocolImp : OnlineClassProtocol{
    
    func getOnlineClass(req: OnlineClassReq) async throws -> OnlineClassRes {
        do{
            let response : OnlineClassRes  = try await APIClient.shared.request(APIEndpoint.createOnlineClass, body: req)
            return response
            
        }catch let error{
           throw error
        }
    }
    
    func readAllOnlineClass() async throws -> ListOnlineClassRes {
        do{
            let response : ListOnlineClassRes = try await APIClient.shared.request(APIEndpoint.readAllOnlineClass)
            return response
        }catch let error{
            throw error
        }
    }
    
    func getOnlineClassById(id: Int) async throws -> OnlineClassByIdRes {
        do{
            let response : OnlineClassByIdRes = try await APIClient.shared.request(APIEndpoint.onlineClassById(id: id))
            return response
        }catch let error{
            throw error
        }
    }
    
    func updateOnlineClass(id: Int, req: UpdateOnlineClassReq) async throws -> UpdateOnlineClassRes {
        do{
            let response : UpdateOnlineClassRes = try await APIClient.shared.request(APIEndpoint.updateOnlineClass(id: id), body:req)
            return response
        }catch let error {
            throw error
        }
    }
    
    func getDeleteOnlineClass(id: Int) async throws -> DeleteOnlineClassRes {
        do{
            let response : DeleteOnlineClassRes = try await APIClient.shared.request(APIEndpoint.deleteOnlineClass(id: id))
            return response
        }catch let error{
            throw error
        }
    }
}
