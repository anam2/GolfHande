//
//  ErrorDisplayView.swift
//  GolfHande
//
//  Created by Andy Nam on 4/15/23.
//

import SwiftUI

enum InformationViewType {
    case error
    case success
}

struct InformationViewParams {
    let imageName: String
    let displayText: String
    let fontSize: CGFloat = 14.0
    let backgroundColor: Color
}

struct InformationView: View {
    let viewType: InformationViewType
    let displayText: String
    var viewParams: InformationViewParams {
        getParams(for: viewType, displayText: displayText)
    }

    var body: some View {
        HStack {
            Image(systemName: viewParams.imageName)
            Text(viewParams.displayText)
                .font(.system(size: viewParams.fontSize))
            Spacer()
        }
        .padding()
        .background(viewParams.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func getParams(for viewType: InformationViewType,
                           displayText: String) -> InformationViewParams {
        switch viewType {
        case .error:
            return InformationViewParams(imageName: "exclamationmark.circle",
                                         displayText: displayText,
                                         backgroundColor: Color.red)
        case .success:
            return InformationViewParams(imageName: "checkmark.circle",
                                         displayText: displayText,
                                         backgroundColor: Color.green)
        }
    }
}
