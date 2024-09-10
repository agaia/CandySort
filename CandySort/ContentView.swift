//
//  ContentView.swift
//  CandySort
//
//  Created by Antoine Gaia on 10/09/2024.
//

import SwiftUI

struct ContentView: View {

    @AppStorage("currentUserLevel")
    var currentUserLevel: Int = 1

    var body: some View {
        NavigationStack {
            VStack {
                levelsCarousel

                ProfileView()
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        InventoryView()
                            .navigationTitle("Unlocked items")
                    } label: {
                        Image(systemName: "cart")
                    }
                }
            })
            .navigationTitle("CandySort")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var levelsCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                NavigationLink {
                    GameContainerView()
                } label: {
                    levelCell(at: currentUserLevel)
                }

                ForEach((1..<currentUserLevel).reversed(), id: \.self) { level in
                    levelCell(at: level)
                }
            }
            .padding()
        }
    }

    private func levelCell(at level: Int) -> some View {
        VStack {
            Text("\(level)")
                .font(.system(size: 36, weight: .black))
                .foregroundStyle(level == currentUserLevel ? .white : .gray.opacity(0.4))
                .padding(.all, 8)
                .background(level == currentUserLevel ? .blue : .gray.opacity(0.2))
                .clipShape(Circle())

            Text(level == currentUserLevel ? "Next" : "")
        }
    }
}
