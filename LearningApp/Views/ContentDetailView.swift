//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Alex Cannizzo on 01/10/2021.
//
import AVKit
import SwiftUI


struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            //Description
            CodeTextView()
            
            // Show Next lesson button only if there is a next lesson
            if model.hasNextLesson() {
                Button {
                    model.nextLesson()
                } label: {
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .frame(height: 48)
                        
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .foregroundColor(.white)
                            .bold()
                    }
                    
                    
                }
            }
        }
        .padding()
        .navigationTitle(lesson?.title ?? "")
    }
}


struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
