//
//  TestView.swift
//  LearningApp
//
//  Created by Alex Cannizzo on 01/10/2021.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var selectedAnswerIndex: Int?
    @State var numCorrect = 0
    @State var submitted = false
    @State var showResults = false
    
    var body: some View {
        
        if model.currentQuestion != nil && showResults == false {
            VStack(alignment: .leading) {
                
                // question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                
                // answers
                ScrollView {
                    VStack {
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            Button {
                                // Track the selected index
                                selectedAnswerIndex = index
                            } label: {
                                ZStack {
                                    
                                    if submitted == false {
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white )
                                            .frame(height: 48)
                                    }
                                    else {
                                        // Answer has been submitted
                                        if index == selectedAnswerIndex &&
                                            index == model.currentQuestion!.correctIndex {
                                            
                                            // User has selected the right answer
                                            // Show a green background
                                            RectangleCard(color: Color.green)
                                                .frame(height: 48)
                                        }
                                        else if index == selectedAnswerIndex &&
                                                    index != model.currentQuestion!.correctIndex {
                                            
                                            // User has selected the wrong answer
                                            // Show a red background
                                            RectangleCard(color: Color.red)
                                                .frame(height: 48)
                                        }
                                        else if index == model.currentQuestion!.correctIndex {
                                            
                                            // This button is the correct answer
                                            // Show a green background
                                            RectangleCard(color: Color.green)
                                                .frame(height: 48)
                                        }
                                        else {
                                            RectangleCard(color: Color.white)
                                                .frame(height: 48)
                                        }
                                        
                                    }
                                    
                                    Text(model.currentQuestion!.answers[index])
                                }
                                
                            }
                            .disabled(submitted)
                            
                        }
                    }
                    .padding()
                    .accentColor(.black)
                }
                
                // button
                Button {
                    
                    // check if answer has been submitted
                    if submitted == true {
                        
                        // check if it's the last question
                        if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                            
                            
                            // show the results
                            showResults = true
                        }
                        else {
                            
                            // answer has already been submitted, move to the next question
                            model.nextQuestion()
                            
                            // reset properties
                            submitted = false
                            selectedAnswerIndex = nil
                        }
                    } else {
                        // submit the answer
                        
                        // change submitted state to true
                        submitted = true
                        
                        // check the answer and increment the counter if correct
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    }
                    
                    
                } label: {
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text(buttonText)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                .disabled(selectedAnswerIndex == nil ? true : false)
                
                
            }
            .navigationTitle("\(model.currentModule?.category ?? "") Test")
        } else if showResults == true {
            TestResultView(numCorrect: numCorrect)
        }
        else {
            ProgressView()
        }
        
    }
    
    var buttonText: String {
        
        // Check if answer has been submitted
        if submitted == true {
            if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                // This is the last question
                return "Finish"
            }
            else {
                // There is a next question
                return "Next"
            }
        }
        else {
            return "Submit"
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(ContentModel())
    }
}
