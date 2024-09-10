//
//  TubeView.swift
//  CandySort
//
//  Created by Antoine Gaia on 10/09/2024.
//

import SwiftUI

struct TubeView: View {

    var tubeIndex: Int

    @Binding var game: Game
    @Binding var selectedCandy: Candy?
    @Binding var sourceTubeIndex: Int?
    @Binding var gameResult: GameResult?
    @Binding var remainingLives: Int
    @Binding var numberOfMoves: Int

    @AppStorage("currentUserPerfectLevels")
    var currentUserPerfectLevels: Int = 0

    var difficulty: Difficulty

    private var isSelected: Bool {
        sourceTubeIndex == tubeIndex
    }

    private var backgroundColor: Color {
        game.tubes[tubeIndex].isCompleted ? .green : (isSelected ? Color.blue : Color.gray)
    }

    var body: some View {
        VStack {
            Spacer()

            ForEach(game.tubes[tubeIndex].candies, id: \.self) { candy in
                CandyView(candy: candy)
            }
        }
        .padding(.vertical, 16)
        .frame(width: 50, height: 200)
        .background(backgroundColor.opacity(0.2))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? backgroundColor : .clear, lineWidth: 2)
        )
        .onTapGesture {
            withAnimation(.bouncy) {
                handleTap()
            }
        }
    }

    func handleTap() {
        UIImpactFeedbackGenerator().impactOccurred()

        // Check if there's currently a selected candy
        if let selectedCandy = selectedCandy, let sourceIndex = sourceTubeIndex {
            // Check if the tap is on a different tube and a valid move

            let consecutiveCandies = getConsecutiveMatchingCandies(from: game.tubes[sourceIndex])

            if tubeIndex != sourceIndex &&
                (game.tubes[tubeIndex].candies.isEmpty ||
                 game.tubes[tubeIndex].candies.first == selectedCandy)
                && (game.tubes[tubeIndex].candies.count + consecutiveCandies.count <= 4)
                 {

                for (index, candy) in consecutiveCandies.enumerated() {
                    if let firstCandy = consecutiveCandies.first, candy == firstCandy {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                            // Place the selected candy in the new tube
                            game.tubes[tubeIndex].candies.insert(selectedCandy, at: 0)
                            // Remove the candy from the original tube
                            game.tubes[sourceIndex].candies.removeFirst()
                            // Clear the selection
//                        }
                    }
                }

                self.selectedCandy = nil
                self.sourceTubeIndex = nil
                numberOfMoves += 1
            } else if tubeIndex == sourceIndex {
                // If the tap is on the same tube, deselect and reset (put the candy back)
                self.selectedCandy = nil
                self.sourceTubeIndex = nil
            } else {
                numberOfMoves += 1
                remainingLives -= 1

                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        } else {
            // No candy is currently selected, try to pick up the top candy from the tapped tube if available
            if let candy = game.tubes[tubeIndex].candies.first {
                // Pick up the candy
                selectedCandy = candy
                sourceTubeIndex = tubeIndex
            }
        }

        guard game.isCompleted else {
            gameResult = nil
            return
        }

        gameResult = .success

        if numberOfMoves < difficulty.movesToPerfect {
            currentUserPerfectLevels += 1
        }
    }

    // Example usage within a function or method:
    func getConsecutiveMatchingCandies(from tube: Tube) -> [Candy] {
        guard let firstCandy = tube.candies.first else {
            return []
        }
        // Get all candies that match the first candy's color consecutively
        return Array(tube.candies.prefix(while: { $0 == firstCandy }))
    }
}
