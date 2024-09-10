//
//  Toast.swift
//  CandySort
//
//  Created by Antoine Gaia on 10/09/2024.
//

import SwiftUI
import ConfettiSwiftUI

enum GameResult {
    case fail
    case success

    var themeColor: Color {
        switch self {
        case .fail: Color.red
        case .success: Color.green
        }
    }

    var title: String {
        switch self {
        case .fail: "You failed..."
        case .success: "You won!"
        }
    }

    var hasNextButton: Bool {
        switch self {
        case .fail: false
        case .success: true
        }
    }
}

struct ResultView: View {

    @State private var counter: Int = 0

    @Binding var game: Game
    @Binding var type: GameResult?
    @Binding var remainingLives: Int
    @Binding var numberOfMoves: Int

    var fromLevel: Int
    var difficulty: Difficulty
    var resetGame: (()->Void)?

    @AppStorage("currentUserLevel")
    var currentUserLevel: Int = 1

    private var hasSniper: Bool {
        numberOfMoves < difficulty.movesToPerfect
    }

    var body: some View {
        VStack(alignment: .center) {
            Text(type?.title ?? "")
                .font(.system(size: 32, weight: .black))
                .foregroundStyle(type?.themeColor ?? .white)

            if type == .success {
                Text("You made it in \(numberOfMoves) moves")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(type?.themeColor ?? .white)

                if hasSniper {
                    Text("+1 🎯 Good job!")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(type?.themeColor ?? .white)
                }
            }

            HStack {
                if type?.hasNextButton ?? false {
                    Button {
                        currentUserLevel = fromLevel + 1
                        resetGame?()
                    } label: {
                        Text("Next level")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.all, 16)
                            .background(type?.themeColor ?? .black)
                            .cornerRadius(16)
                    }
                }

                Button {
                    resetGame?()
                } label: {
                    Text("Retry")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.all, 16)
                        .background(type?.themeColor ?? .black)
                        .cornerRadius(16)
                }
            }
            .foregroundStyle(.white)
            .padding(.all, 16)
        }
        .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.5)
        .background(Color.black)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.2), lineWidth: 2)
        )
        .confettiCannon(counter: $counter, repetitions: 10, repetitionInterval: 2)
        .onAppear {
            if type == .success {
                counter += 1
            }
        }
    }
}
