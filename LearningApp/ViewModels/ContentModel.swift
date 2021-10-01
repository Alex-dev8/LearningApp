//
//  ContentModel.swift
//  LearningApp
//
//  Created by Alex Cannizzo on 30/09/2021.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // current lesson explanation
    @Published var lessonDescription = NSAttributedString()
    var styleData: Data?
    
    init() {
        getLocalData()
    }
    
    // MARK: - Data methods
    
    func getLocalData() {
        
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            let jsonData = try Data(contentsOf: jsonUrl!)
            let jsonDecoder = JSONDecoder()
            
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            self.modules = modules
        } catch {
            print(error)
        }
        
        
        // Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            let styleData = try Data(contentsOf: styleUrl!)
            self.styleData = styleData
        } catch {
            print(error)
        }
    }
    
    // MARK: - Module navigation methods
    
    func beginModule(_ moduleid: Int) {
        // find index for module id
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                // found the matching module
                currentModuleIndex = index
                break
            }
        }
        
        // set the current module
        currentModule = modules[currentModuleIndex]
        print("The current module is \(currentModuleIndex)")
    }
    
    func beginLesson(_ lessonIndex: Int) {
        
        // Check that the lesson index is within range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
            
        } else {
            currentLessonIndex = 0
        }
        
        // set the current lesson
        currentLesson = currentModule!.content.lessons[0]
        lessonDescription = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson() {
        // advance the lesson index
        currentLessonIndex += 1
        
        // check that it is in within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            // set current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            lessonDescription = addStyling(currentLesson!.explanation)
        } else {
            // reset lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    func hasNextLesson() -> Bool {
        if currentLessonIndex + 1 < currentModule!.content.lessons.count {
            return true
        } else {
            return false
        }
    }
    
    
    // MARK: - Code Styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        var resultString = NSAttributedString()
        var data = Data()
        
        // add styling data
        if styleData != nil {
            data.append(self.styleData!)
        }
        // add html data
        data.append(Data(htmlString.utf8))
        
        // convert to attributed string
        
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            resultString = attributedString
        }
        
        return resultString
    }
    
}
