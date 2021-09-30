//
//  ContentView.swift
//  Multiplications
//
//  Created by Antonio Zdelican on 29.09.21.
//

import SwiftUI

// MARK: - Enums & Structs

enum GameState {
    case settings, active, finished
}

enum AnswerState {
    case input, correct, wrong
}

enum GameButtonState {
    case disabled, check, next
}

enum NumberOfQuestions: String {
    case five = "5"
    case ten = "10"
    case twenty = "20"
    case all = "All"
}

struct Question {
    var questionText: String
    var answer: Int
}

struct TimesTable {
    var questions: [Question] = []
}

// MARK: - ViewModifiers

struct NumberPadButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .frame(width: 60, height: 60)
            .foregroundColor(.black)
            .background(Color.black.opacity(0.2))
            .clipShape(Circle())
    }
}

struct GameButton: ViewModifier {
    var isDisabled: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: 50)
            .background(isDisabled ? Color.themePurple.opacity(0.4) : Color.themePurple)
            .foregroundColor(isDisabled ? .white.opacity(0.4) : .white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct AnswerView: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .frame(width: 200, height: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color, lineWidth: 1)
                )
    }
}

// MARK: - Extensions

extension View {
    func numberPadButton() -> some View {
        self.modifier(NumberPadButton())
    }
    
    func gameButton(isDisabled: Bool = false) -> some View {
        self.modifier(GameButton(isDisabled: isDisabled))
    }
    
    func answerView(color: Color) -> some View {
        self.modifier(AnswerView(color: color))
    }
}

extension Color {
    static let themeGreen = Color(.sRGB, red: 22 / 255, green: 134 / 255, blue: 79 / 255, opacity: 1.0)
    static let themePurple = Color(.sRGB, red: 138 / 255, green: 43 / 255, blue: 226 / 255, opacity: 1.0)
}

// MARK: - Main

struct ContentView: View {
    @State private var gameState: GameState = .settings
    
    @State private var selectedTimesTableIndex: Int = 0
    @State private var selectedNumberOfQuestionsIndex: Int = 0
    @State private var totalNumberOfQuestions: Int = 5
    
    @State private var currentQuestionIndex: Int = 0
    @State private var randomQuestions: [Question] = []
    @State private var correctAnswers: Int = 0
    
    @State private var answerState: AnswerState = .input
    @State private var answerInput: String = ""
    @State private var answerMessage: String = ""
    
    @State private var gameButtonState: GameButtonState = .disabled
    
    private var timesTables: [TimesTable] {
        var timesTables = [TimesTable](repeating: TimesTable(), count: 12)
        for firstNumber in 1...12 {
            for secondNumber in 1...12 {
                let questionText = "What is \(firstNumber) x \(secondNumber)?"
                let answer = firstNumber * secondNumber
                let question = Question(questionText: questionText, answer: answer)
                
                timesTables[firstNumber - 1].questions.append(question)
                if secondNumber != firstNumber {
                    // Don't add the duplicate
                    timesTables[secondNumber - 1].questions.append(question)
                }
            }
        }
        return timesTables
    }
    
    private var numberOfQuestions: [NumberOfQuestions] = [.five, .ten, .twenty, .all]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            Group {
                switch gameState {
                case .settings:
                    settingsView
                case .active:
                    activeGameView
                case .finished:
                    finishedGameView
                }
            }
        }
    }
    
    // MARK: - Views
    
    var settingsView: some View  {
        VStack(spacing: 50) {
            VStack(spacing: 10) {
                Text("Multiplications")
                    .font(.title)
                    .fontWeight(.black)
                Text("Before the game, select your settings:")
            }
            
            VStack(spacing: 30) {
                VStack {
                    Text("\(selectedTimesTableIndex + 1) times table")
                        .font(.title2)
                        .fontWeight(.medium)
                    Stepper("", value: $selectedTimesTableIndex, in: 0...11)
                        .labelsHidden()
                }
                
                VStack {
                    Text("\(numberOfQuestions[selectedNumberOfQuestionsIndex].rawValue) questions")
                        .font(.title2)
                        .fontWeight(.medium)
                    Stepper("", value: $selectedNumberOfQuestionsIndex, in: 0...numberOfQuestions.count - 1)
                        .labelsHidden()
                        .onChange(of: selectedNumberOfQuestionsIndex, perform: { value in
                            calculateTotalNumberOfQuestions()
                        })
                }
            }
            
            Button(action: startGameButtonTapped) {
                Text("Start game")
                    .gameButton()
            }
        }
        .multilineTextAlignment(.center)
        .padding()
    }
    
    var activeGameView: some View  {
        VStack(spacing: 50) {
            VStack {
                Text("\(selectedTimesTableIndex + 1) Times Table")
                    .font(.title)
                    .fontWeight(.black)
                Text("Question \(currentQuestionIndex + 1)/\(totalNumberOfQuestions)")
            }
            numberPadView
        }
    }
    
    var finishedGameView: some View {
        VStack(spacing: 30) {
            VStack {
                Text("Game Finished")
                    .font(.title)
                    .fontWeight(.black)
                Text("Your score: \(correctAnswers)/\(totalNumberOfQuestions)")
            }
            
            Button(action: startGameButtonTapped) {
                Text("Restart")
                    .gameButton()
            }
            
            Button(action: backToSettingsButtonTapped) {
                Text("Back to settings")
                    .gameButton()
            }
        }
    }
    
    var numberPadView: some View {
        VStack(spacing: 20) {
            Text("\(randomQuestions[currentQuestionIndex].questionText)")
                .font(.title2)
                .fontWeight(.medium)
            
            answerView
            
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    ForEach(1..<4) { number in
                        Button(action: {
                            self.numberPadButtonTapped(String(number))
                        }) {
                            Text("\(number)")
                                .numberPadButton()
                        }
                    }
                }
                HStack(spacing: 10)  {
                    ForEach(4..<7) { number in
                        Button(action: {
                            self.numberPadButtonTapped(String(number))
                        }) {
                            Text("\(number)")
                                .numberPadButton()
                        }
                    }
                }
                HStack(spacing: 10)  {
                    ForEach(7..<10) { number in
                        Button(action: {
                            self.numberPadButtonTapped(String(number))
                        }) {
                            Text("\(number)")
                                .numberPadButton()
                        }
                    }
                }
                HStack(spacing: 10)  {
                    Spacer()
                        .frame(width: 60, height: 60)
                    Button(action: {
                        self.numberPadButtonTapped("0")
                    }) {
                        Text("0")
                            .numberPadButton()
                    }
                    Button(action: {
                        self.numberPadButtonTapped("⌫")
                    }) {
                        Text("⌫")
                            .numberPadButton()
                    }
                }
            }
            
            gameButtonView
        }
    }
    
    var answerView: some View {
        Group {
            switch answerState {
            case .input:
                Text("\(answerInput)")
                    .font(.title)
                    .fontWeight(.black)
                    .answerView(color: .black)
            case .correct:
                Text("\(answerMessage)")
                    .font(.title2)
                    .fontWeight(.medium)
                    .answerView(color: Color.themeGreen)
            case .wrong:
                Text("\(answerMessage)")
                    .font(.title2)
                    .fontWeight(.medium)
                    .answerView(color: .red)
            }
        }
    }
    
    var gameButtonView: some View {
        Group {
            switch gameButtonState {
            case .disabled:
                Button(action: {}) {
                    Text("Check")
                        .gameButton(isDisabled: true)
                }
                .disabled(true)
            case .check:
                Button(action: checkButtonTapped) {
                    Text("Check")
                        .gameButton()
                }
            case .next:
                Button(action: nextButtonTapped) {
                    Text("Next")
                        .gameButton()
                }
            }
        }
    }
    
    // MARK: - Functions
    
    func calculateTotalNumberOfQuestions() {
        switch numberOfQuestions[selectedNumberOfQuestionsIndex] {
        case .five:
            totalNumberOfQuestions = 5
        case .ten:
            totalNumberOfQuestions = 10
        case .twenty:
            totalNumberOfQuestions = 20
        case .all:
            totalNumberOfQuestions = timesTables[selectedTimesTableIndex].questions.count
        }
    }
    
    func restartNumberPadData() {
        answerState = .input
        answerInput = ""
        answerMessage = ""
        gameButtonState = .disabled
    }
    
    // MARK: - Buttons
    
    func startGameButtonTapped() {
        gameState = .active
        /// Fresh init of states
        let allQuestions = timesTables[selectedTimesTableIndex].questions
        randomQuestions = Array(allQuestions.shuffled().prefix(totalNumberOfQuestions))
        currentQuestionIndex = 0
        correctAnswers = 0
        restartNumberPadData()
    }
    
    func numberPadButtonTapped(_ value: String) {
        if gameButtonState == .next {
            return
        }
        if value != "⌫" && answerInput.count > 2 {
            return
        }
        if value == "0" && answerInput.count == 0 {
            return
        }
        if value == "⌫" && answerInput.count == 0 {
            return
        }
        if value == "⌫" {
            answerInput.removeLast()
        } else {
            answerInput.append(value)
        }
        gameButtonState = answerInput.count == 0 ? .disabled : .check
    }
    
    func checkButtonTapped() {
        let correctAnswer = randomQuestions[currentQuestionIndex].answer
        if Int(answerInput) == correctAnswer {
            answerMessage = "Correct, it's \(correctAnswer)!"
            answerState = .correct
            correctAnswers += 1
        } else {
            answerMessage = "Oops - it's \(correctAnswer)."
            answerState = .wrong
        }
        gameButtonState = .next
    }
    
    func nextButtonTapped() {
        currentQuestionIndex += 1
        if currentQuestionIndex == totalNumberOfQuestions {
            gameState = .finished
        } else {
            restartNumberPadData()
        }
    }
    
    func backToSettingsButtonTapped() {
        gameState = .settings
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
