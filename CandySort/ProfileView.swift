//
//  ProfileView.swift
//  CandySort
//
//  Created by Antoine Gaia on 10/09/2024.
//

import SwiftUI

enum Award: String, CaseIterable {
    case beginner
    case intermediate
    case advanced
    case expert
    case master
    case grandMaster
    case god
    case sniper

    var neededGames: Int? {
        switch self {
        case .beginner: 3
        case .intermediate: 10
        case .advanced: 25
        case .expert: 50
        case .master: 100
        case .grandMaster: 200
        case .god: 500
        default: nil
        }
    }

    var neededPerfectGames: Int? {
        switch self {
        case .sniper: 10
        default: nil
        }
    }

    var icon: Image {
        switch self {
        case .beginner, .intermediate, .advanced, .expert, .master, .grandMaster, .god:
                .init(systemName: "trophy.fill")
        case .sniper:
                .init(systemName: "target")
        }
    }

    var unlockItem: [String] {
        switch self {
        case .beginner:
            return ["🧢", "👕", "👟"]
        case .intermediate:
            return ["🕶️", "👖", "⌚"]
        case .advanced:
            return ["🧥", "🥾", "🎒"]
        case .expert:
            return ["🦺", "🎧", "🔩"]
        case .master:
            return ["🧥✨", "👑", "🔫"]
        case .grandMaster:
            return ["🥋", "🏆", "🥇"]
        case .god:
            return ["☀️", "🔥", "💦"]
        case .sniper:
            return ["🎯"]
        }
    }

    var next: Award? {
        switch self {
        case .beginner: .intermediate
        case .intermediate: .advanced
        case .advanced: .expert
        case .expert: .master
        case .master: .grandMaster
        case .grandMaster: .god
        default: nil
        }
    }

    var description: String? {
        switch self {
        case .sniper:
            "Complete 10 levels in limited moves to unlock this badge"
        default: nil
        }
    }

    func hasCompleted(with value: Int) -> Bool {
        guard let neededGames else { return false }
        return value - 1 >= neededGames
    }

    func hasCompletedSniper(with value: Int) -> Bool {
        guard let neededPerfectGames = neededPerfectGames else { return false }
        return value >= neededPerfectGames
    }
}

struct ProfileView: View {

    @AppStorage("currentUserLevel")
    var currentUserLevel: Int = 0

    @AppStorage("currentUserPerfectLevels")
    var currentUserPerfectLevels: Int = 0

    @AppStorage("userSpeedRecord")
    var userSpeedRecord: Double = 1000

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Award.allCases, id:\.self) { award in
                    badgeView(for: award)
                }
            }
        }
    }

    private func badgeView(for target: Award) -> some View {
        let hasCompleted: Bool = target.hasCompleted(with: currentUserLevel) || target.hasCompletedSniper(with: currentUserPerfectLevels)
        let badgeColor: Color = hasCompleted ? .yellow : .gray
        let completionColor: Color = hasCompleted ? .green : .gray

        return HStack(spacing: 8) {
            target.icon
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(badgeColor)
                .padding(.all, 8)
                .background(badgeColor.opacity(0.2))
                .cornerRadius(8)

            VStack(alignment: .leading) {
                HStack {
                    Text(target.rawValue.capitalized)
                        .font(.system(size: 16, weight: .medium))

                    ForEach(target.unlockItem, id:\.self) { item in
                        Text(item)
                            .font(.system(size: 16, weight: .medium))
                    }

                    Spacer()

                    if let neededGames = target.neededGames {
                        Text("\(currentUserLevel - 1) / \(neededGames)")
                            .font(.caption)
                            .foregroundStyle(completionColor)
                    }

                    if let neededPerfectGames = target.neededPerfectGames {
                        Text("\(currentUserPerfectLevels) / \(neededPerfectGames)")
                            .font(.caption)
                            .foregroundStyle(completionColor)
                    }
                }

                if let neededGames = target.neededGames {
                    ProgressView("", value: Double(currentUserLevel), total: Double(neededGames))
                        .tint(completionColor)
                }

                if let description = target.description {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                }
            }

            Spacer()
        }
        .padding(.all, 16)
    }
}

#Preview {
    ProfileView()
}

