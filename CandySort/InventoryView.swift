//
//  InventoryView.swift
//  CandySort
//
//  Created by Antoine Gaia on 10/09/2024.
//

import SwiftUI

struct InventoryView: View {

    @AppStorage("currentUserLevel")
    private var currentUserLevel: Int = 0

    private var unlockedLevels: [Award] {
        Award.allCases.filter {
            $0.hasCompleted(with: currentUserLevel)
        }
    }

    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(unlockedLevels, id: \.self) { level in
                    ForEach(level.unlockItem, id:\.self) { item in
                        Text(item)
                            .font(.system(size: 64))
                    }
                }
            }
        }
    }
}

#Preview {
    InventoryView()
}
