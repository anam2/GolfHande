//
//  CoreSwiftUI.swift
//  GolfHande
//
//  Created by Andy Nam on 4/12/23.
//

import SwiftUI

struct CoreSwiftUI {
    static func button(text: String, action: @escaping () -> Void) -> some View {
        return Button(action: action) {
            Text(text)
                .frame(width: 150.0)
                .font(.system(size: 12.0))
                .foregroundColor(Color.white)
                .padding()
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
        }
    }

    static func textField(text: String, bindingText: Binding<String>) -> some View {
        TextField(text, text: bindingText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }

    /**
     Creates the default secure text field for GolfHandE.
     - Parameters:
        - text: (String) The placeholder text that is going to be displayed.
        - bindingText: (Binding<String>) The binding variable that is going to bind to this secure field.
     */
    static func secureField(text: String, bindingText: Binding<String>) -> some View {
        SecureField(text, text: bindingText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }

    static func loadingIndicatorView(isLoading: Bool) -> some View {
        ZStack {
            if isLoading {
                Color.black.opacity(0.1)
                    .zIndex(0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .disabled(true)
                ProgressView()
                    .zIndex(1)
            }
        }
    }
}
