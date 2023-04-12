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
        }
    }
}
