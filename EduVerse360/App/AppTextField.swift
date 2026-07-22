//
//  AppTextField.swift
//  EduVerse360
//
//  Created by Ekta Rai on 19/07/2026.
//

import SwiftUI

struct AppTextField : View {
    
    let title:String
    let imageName : String
    let placeholder : String
    let field : Field
    let error: String?
    
    @Binding var text: String
    @FocusState.Binding var focusedField: Field?
    
    
    var body: some View {
        
        
        //email
        VStack(alignment:.leading, spacing: 10) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondaryText)
                .fontWeight(.semibold)
            
            VStack(alignment:.leading, spacing:nil){
                HStack {
                    Image(imageName)
                        .foregroundStyle(.gray)
                        .padding()
                    
                    TextField(placeholder,text: $text)
                        .focused($focusedField, equals:field)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                   
                    }
                .frame(width:300, height:45)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.textFieldColor, lineWidth: 1)
                    
                )
                if let error {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                    }
                
                
            }
            
        }
        .padding(.bottom)
       
        
        
        
        
        
        
    }
}

