//
//  LevelFactory.swift
//  CandySort
//
//  Created by Antoine Gaia on 10/09/2024.
//

import SwiftUI

struct Game: Identifiable {

    let id = UUID()

    var tubes: [Tube]

    init(tubes: [Tube] = []) {
        self.tubes = tubes
    }

    var isCompleted: Bool {
        return tubes.filter({ $0.isCompleted || $0.candies.isEmpty }).count == tubes.count
    }
}

struct Tube: Identifiable {
    let id = UUID()
    var candies: [Candy]

    init(candies: [Candy] = []) {
        self.candies = candies
    }

    var isCompleted: Bool {
        guard let firstColor = candies.first,
              candies.count == 4 else {
            return false
        }
        return candies.allSatisfy { $0 == firstColor }
    }
}

struct LevelFactory {

    static let shared: LevelFactory = .init()

    let maxColors: Int = Candy.allCases.count
    let maxTubes: Int = 10

    func generateLevel(for currentUserLevel: Int) -> Game {
        let numColors = calculateNumberOfColors(currentUserLevel: currentUserLevel)
        let candiesPerColor = calculateCandiesPerColor(currentUserLevel: currentUserLevel)
        let numTubes = calculateNumberOfTubes(numColors: numColors, currentUserLevel: currentUserLevel)

        // Generate candies and distribute them into tubes
        var candyPool: [Candy] = []
        for colorIndex in 0..<numColors {
            let color = Candy.allCases[colorIndex % Candy.allCases.count]
            candyPool += Array(repeating: color, count: candiesPerColor)
        }

        candyPool.shuffle()  // Shuffle candies for a challenging start
        
        return .init(tubes: distributeCandiesIntoTubes(candyPool: candyPool, numTubes: numTubes))
    }

    private func calculateNumberOfColors(currentUserLevel: Int) -> Int {
        min(maxColors, 2 + (currentUserLevel / 2))
    }

    private func calculateCandiesPerColor(currentUserLevel: Int) -> Int {
        4
    }

    private func calculateNumberOfTubes(numColors: Int, currentUserLevel: Int) -> Int {
        min(numColors + max(2, currentUserLevel / 5), maxTubes)
    }

    private func distributeCandiesIntoTubes(candyPool: [Candy], numTubes: Int) -> [Tube] {
        var tubes = Array(repeating: Tube(candies: []), count: numTubes)
        for (index, candy) in candyPool.enumerated() {
            tubes[index % numTubes].candies.append(candy)
        }
        return tubes
    }
}
