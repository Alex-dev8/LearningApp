//
//  ContentView.swift
//  LearningApp
//
//  Created by Alex Cannizzo on 01/10/2021.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        
        ScrollView {
            LazyVStack {
                // confirm that current module is set
                if model.currentModule != nil {
                    ForEach(0..<model.currentModule!.content.lessons.count) { index in
                        NavigationLink  {
                            ContentDetailView()
                                .onAppear {
                                    model.beginLesson(index)
                                    print(index)
                                }
                        } label: {
                            ContentViewRow(index: index)
                        }
                        
                        
                    }
                }
            }
            .accentColor(.black)
            .padding()
            .navigationTitle("Learn \(model.currentModule?.category ?? "")")
        }
        
    }
}

