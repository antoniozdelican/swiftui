//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Antonio Zdelican on 20.09.21.
//

import SwiftUI

enum Move: String, CaseIterable {
    case rock = "Rock"
    case paper = "Paper"
    case scissors = "Scissors"
}

enum Prompt: String, CaseIterable {
    case win = "WIN"
    case loose = "LOOSE"
}

struct ContentView: View {
    @State private var appMove = Move.allCases.randomElement()!
    @State private var appPrompt = Prompt.allCases.randomElement()!
    
    @State private var numberOfGames = 1
    @State private var showingScore = false
    @State private var scoreMessage = ""
    @State private var userScore = 0
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                if numberOfGames <= 5 {
                    VStack(spacing: 10) {
                        Text("I chose my move. Select a move to:")
                        Text(appPrompt.rawValue)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    ForEach(Move.allCases, id: \.self) { move in
                        Button(action: {
                            if numberOfGames <= 5 {
                                moveTapped(move)
                            }
                        }) {
                            Text(move.rawValue)
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    }
                } else {
                    VStack(spacing: 10) {
                        Text("The game finished")
                        Text("Your score: \(userScore)")
                        Button(action: {
                            retry()
                        }) {
                            Text("Retry")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    }
                }
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text("Info"), message: Text("\(scoreMessage)"), dismissButton: .default(Text("Continue")) {
                self.reset()
            })
        }
    }
    
    func moveTapped(_ userMove: Move) {
        var userPrompt: Prompt?
        switch appMove {
        case .rock:
            if userMove == .paper {
                userPrompt = .win
            } else if userMove == .scissors {
                userPrompt = .loose
            }
        case .paper:
            if userMove == .scissors {
                userPrompt = .win
            } else if userMove == .rock {
                userPrompt = .loose
            }
        case .scissors:
            if userMove == .rock {
                userPrompt = .win
            } else if userMove == .paper {
                userPrompt = .loose
            }
        }
        
        var scoreMessageVerdict = ""
        if let userPrompt = userPrompt {
            if userPrompt == appPrompt {
                userScore += 1
                scoreMessageVerdict = "add 1 point."
            } else {
                if userScore > 0 {
                    userScore -= 1
                }
                scoreMessageVerdict = "loose 1 point."
            }
        } else {
            scoreMessageVerdict = "it's a draw."
        }
        scoreMessage = """
        The app chose \(appMove.rawValue),
        the player was trying to \(appPrompt.rawValue),
        the player tapped \(userMove.rawValue),
        so \(scoreMessageVerdict)
        """
        
        showingScore = true
        numberOfGames += 1
    }
    
    func reset() {
        appMove = Move.allCases.randomElement()!
        appPrompt = Prompt.allCases.randomElement()!
    }
    
    func retry() {
        reset()
        numberOfGames = 1
        userScore = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
