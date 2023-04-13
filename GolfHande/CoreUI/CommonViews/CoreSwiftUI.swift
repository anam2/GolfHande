//
//  CoreSwiftUI.swift
//  GolfHande
//
//  Created by Andy Nam on 4/12/23.
//

import SwiftUI

struct CoreSwiftUI {
    static func button(text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text)
                .frame(width: 80.0)
                .font(.system(size: 12.0))
                .foregroundColor(Color.white)
                .padding()
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
        }
    }
}
