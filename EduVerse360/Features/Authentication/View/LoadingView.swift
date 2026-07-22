//
//  LoadingView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 22/07/2026.
//


import SwiftUI

struct LoadingView : View{
    let message: String
    var body : some View{
        HStack{
           Text(message)
        ProgressView()
                
        }
        
    }
}

#Preview {
    LoadingView(message:"loading")
}
