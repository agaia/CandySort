//
//  LivesView.swift
//  CandySort
//
//  Created by Antoine Gaia on 10/09/2024.
//

import SwiftUI

struct LivesAmount: View {

    private var totalLives: Int = 3

    @Binding var remainingLives: Int

    init(remainingLives: Binding<Int>) {
        self._remainingLives = remainingLives
    }

    var body: some View {
        HStack {
            ForEach(0..<totalLives) { index in
                Image(systemName: "heart.fill")
                    .foregroundStyle(index < remainingLives ? .red : .red.opacity(0.2))
            }
        }
    }
}
