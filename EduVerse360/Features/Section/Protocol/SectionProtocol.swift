//
//  Untitled.swift
//  EduVerse360
//
//  Created by Ekta Rai on 20/08/2026.
//
import Foundation

protocol SectionProtocol{
    
    func createSection(req:SectionReq,id:String) async throws -> SectionRes
    func listSection()async throws -> ListSectionRes
    func getClassSectionById(id:String) async throws -> ClassSectionByIdRes
    func getSectionById(id:Int) async throws -> SectionById
    func getUpdateSection(id:Int,req:UpdateSectionReq) async throws ->UpdateSectionRes
    func getDeleteSec(id:Int) async throws -> DeleteSecRes
}
