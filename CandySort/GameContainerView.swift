//
//  ContentView.swift
//  CandySort
//
//  Created by Antoine Gaia on 10/09/2024.
//

import SwiftUI

enum Difficulty: String, CaseIterable {
    case easy
    case medium
    case hard
    case impossible

    var range: ClosedRange<Int> {
        switch self {
        case .easy: 1...10
        case .medium: 11...20
        case .hard: 21...30
        case .impossible: 31...50
        }
    }

    var color: Color {
        switch self {
        case .easy:
                .cyan
        case .medium:
                .yellow
        case .hard:
                .orange
        case .impossible:
                .red
        }
    }

    var movesToPerfect: Int {
        switch self {
        case .easy:
                10
        case .medium:
                20
        case .hard:
                30
        case .impossible:
                40
        }
    }
}

struct GameContainerView: View {

    @State private var game: Game = .init(tubes: [])
    @State private var toast: GameResult? = nil
    @State private var selectedCandy: Candy?
    @State private var sourceTubeIndex: Int?
    @State private var gameResult: GameResult? = nil
    @State private var remainingLives: Int = 3
    @State private var currentGame: Game?
    @State private var numberOfMoves: Int = 0

    @AppStorage("currentUserLevel")
    var currentUserLevel: Int = 1

    private var difficulty: Difficulty {
        Difficulty.allCases.first(where: { $0.range.contains(currentUserLevel) }) ?? .easy
    }

    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack {
                        Text("Make it under \(difficulty.movesToPerfect) moves to unlock 🎯")
                            .font(.system(size: 18, weight: .light))
                        Text("\(difficulty.movesToPerfect - numberOfMoves) remaining")
                            .font(.system(size: 32, weight: .black))
                            .foregroundStyle(difficulty.movesToPerfect > numberOfMoves ? .green : .gray.opacity(0.5))
                    }
                    .padding(.vertical, 16)

                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(game.tubes.indices, id: \.self) { tubeIndex in
                            TubeView(
                                tubeIndex: tubeIndex,
                                game: $game,
                                selectedCandy: $selectedCandy,
                                sourceTubeIndex: $sourceTubeIndex,
                                gameResult: $gameResult,
                                remainingLives: $remainingLives,
                                numberOfMoves: $numberOfMoves,
                                difficulty: difficulty
                            )
                        }
                    }

                    Spacer()
                }

                if gameResult != nil  {
                    ResultView(
                        game: $game,
                        type: $gameResult,
                        remainingLives: $remainingLives,
                        numberOfMoves: $numberOfMoves,
                        fromLevel: currentUserLevel,
                        difficulty: difficulty
                    ) {
                        newGame()
                    }
                }

                VStack {
                    Spacer()

                    Button {
                        withAnimation {
                            reset()
                        }
                    } label: {
                        Text("Reset")
                            .foregroundStyle(.white)
                            .font(.system(size: 24, weight: .bold))
                            .padding(.all, 16)
                            .background(.blue)
                            .cornerRadius(16)
                    }

                }
            }
            .padding()
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    LivesAmount(remainingLives: $remainingLives)
                }
            })
        }
        .onChange(of: gameResult, { _, newValue in
            guard let newValue else { return }

            toast = newValue
        })
        .onChange(of: remainingLives, { _, newValue in
            if newValue < 1 {
                gameResult = .fail
            }
        })
        .navigationTitle("Level \(currentUserLevel)")
        .onAppear {
            let levelFactory = LevelFactory()
            game = levelFactory.generateLevel(for: currentUserLevel)
            currentGame = game
        }
    }

    private func newGame() {
        gameResult = nil
        game = LevelFactory().generateLevel(for: currentUserLevel)
        currentGame = game
        remainingLives = Constants.maxLives
        sourceTubeIndex = nil
        selectedCandy = nil
        numberOfMoves = 0
    }

    private func reset() {
        if let currentGame {
            gameResult = nil
            game = currentGame
            remainingLives = Constants.maxLives
            sourceTubeIndex = nil
            selectedCandy = nil
            numberOfMoves = 0
        }
    }
}
