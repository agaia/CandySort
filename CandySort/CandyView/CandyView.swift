//
//  CandyView.swift
//  CandySort
//
//  Created by Antoine Gaia on 10/09/2024.
//

import SwiftUI

enum Candy: String, Identifiable, CaseIterable {
    case red, blue, yellow, green, purple, teal, brown
    var id: String { rawValue }
}

struct CandyView: View {
    var candy: Candy

    var body: some View {
        Circle()
            .fill(candyColor(candy))
            .frame(width: 30, height: 30)
            .padding(2)
    }

    func candyColor(_ candy: Candy) -> Color {
        switch candy {
        case .red:
            return .red
        case .blue:
            return .blue
        case .yellow:
            return .yellow
        case .green:
            return .green
        case .purple:
            return .purple
        case .teal:
            return .teal
        case .brown:
            return .brown
        }
    }
}


#Preview {
    CandyView(candy: .red)
}
