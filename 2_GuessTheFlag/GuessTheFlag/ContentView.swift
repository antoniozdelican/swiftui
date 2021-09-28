//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Antonio Zdelican on 10.09.21.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    var opacity: Double = 1
    var rotationDeegres: Double = 0
    var wrongRotationDeegres: Double = 0
    var offset: CGFloat = 0
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: Color.black, radius: 2)
            
            .opacity(opacity)
            .animation(opacity == 1 ? nil : Animation.easeOut(duration: 1))
            .rotation3DEffect(.degrees(rotationDeegres), axis: (x: 0.0, y: 1.0, z: 0.0))
            .rotation3DEffect(.degrees(wrongRotationDeegres), axis: (x: 1.0, y: 0.0, z: 0.0))
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var scoreMessage = ""
    
    @State private var animationAmount = 0.0
    @State private var wrongAnimationAmount = 0.0
    @State private var correctButtonTapped = false
    
    @State private var buttonTapped = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                        if buttonTapped {
                            withAnimation {
                                self.animationAmount += 360
                                self.wrongAnimationAmount += 360
                            }
                        }
                    }) {
                        if buttonTapped {
                            FlagImage(country: self.countries[number], opacity: self.getOpacity(number), rotationDeegres: self.getRotationDegrees(number), wrongRotationDeegres: self.getWrongRotationDegrees(number))
                        } else {
                            FlagImage(country: self.countries[number])
                        }
                    }
                }
                
                Text("Your score is \(userScore)")
                    .foregroundColor(.white)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("\(scoreMessage)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
            scoreMessage = "Your score is \(userScore)"
            correctButtonTapped = true
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "That’s the flag of \(countries[number])"
            correctButtonTapped = false
        }
        showingScore = true
        buttonTapped = true
    }
    
    func getOpacity(_ number: Int) -> Double {
        if number == correctAnswer {
            return 1.0
        } else {
            return 0.25
        }
    }
    
    func getRotationDegrees(_ number: Int) -> Double {
        if number == correctAnswer && correctButtonTapped {
            return animationAmount
        } else {
            return 0
        }
    }
    
    func getWrongRotationDegrees(_ number: Int) -> Double {
        if number == correctAnswer && !correctButtonTapped {
            return wrongAnimationAmount
        } else {
            return 0
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        buttonTapped = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
