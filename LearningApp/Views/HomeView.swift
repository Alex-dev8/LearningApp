//
//  HomeView.swift
//  LearningApp
//
//  Created by Alex Cannizzo on 30/09/2021.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("What do you want to do today?")
                    .padding(.leading)
                
                ScrollView {
                    LazyVStack {
                        ForEach(model.modules) { module in
                            VStack(spacing: 20) {
                                
                                NavigationLink(
                                    destination:
                                        ContentView()
                                        .onAppear(perform: {
                                            model.beginModule(module.id)
                                            
                                        }),
                                    tag: module.id,
                                    selection: $model.currentContentSelected,
                                    
                                    label: {
                                        // learning card
                                        HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                    })
                                
                                NavigationLink(tag: module.id, selection: $model.currentTestSelected) {
                                    TestView()
                                        .onAppear {
                                            model.beginTest(module.id)
                                        }
                                        
                                } label: {
                                    // test card
                                    HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Lessons", time: module.test.time)
                                }
                                
                                NavigationLink {
                                    EmptyView()
                                } label: {
                                    
                                }

                            }
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
            }
            .navigationTitle("Get Started")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
