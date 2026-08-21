//
//  Untitled.swift
//  EduVerse360
//
//  Created by Ekta Rai on 20/08/2026.
//
import Foundation

protocol SectionProtocol{
    
    func createSection(req:SectionReq,id:String) async throws -> SectionRes
}
