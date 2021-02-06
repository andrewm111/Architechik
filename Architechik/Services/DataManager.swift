//
//  DataManager.swift
//  Architechik
//
//  Created by Александр Цветков on 03.02.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    
    static let shared = DataManager()
    fileprivate init() {}
    
    let managedContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        }
        return appDelegate.persistentContainer.viewContext
    }()
    let coursesFetchRequest = NSFetchRequest<CourseCD>(entityName: "CourseCD")
    let articlesFetchRequest = NSFetchRequest<ArticleCD>(entityName: "ArticleCD")
    let grammarFetchRequest = NSFetchRequest<GrammarCD>(entityName: "GrammarCD")
    let achievementFetchRequest = NSFetchRequest<AchievementCD>(entityName: "AchievementCD")
    let lessonsFetchRequest = NSFetchRequest<LessonCD>(entityName: "LessonCD")
    
    //MARK: - Save
    func saveCourses(_ array: Array<Course>) {
        let courses = array.sorted(by: { $0.id < $1.id } )
        guard let entity = NSEntityDescription.entity(forEntityName: "CourseCD", in: managedContext) else { return }
        var coursesCD = fetchAllCourses().sorted(by: { $0.id < $1.id } )
        let diff = coursesCD.count - array.count
        if diff > 0 {
            for course in coursesCD.dropFirst(coursesCD.count - diff) {
                managedContext.delete(course)
            }
            coursesCD = Array(coursesCD.dropFirst(coursesCD.count - diff))
        } else if diff < 0 {
            let newCourses = array[coursesCD.count...array.count - 1]
            _ = newCourses.map({ course in
                let model = CourseCD(entity: entity, insertInto: managedContext)
                model.configure(withModel: course)
            })
        }
        _ = courses.map { course in
            for courseCD in coursesCD {
                if courseCD.id == course.id {
                    courseCD.configure(withModel: course)
                    continue
                }
            }
        }
        do {
            try managedContext.save()
        } catch {
            print("Error with saving courses to Core Data: \(error)")
        }
    }
    
    func saveArticles(_ array: Array<Article>) {
        let articles = array.sorted(by: { $0.id < $1.id } )
        guard let entity = NSEntityDescription.entity(forEntityName: "ArticleCD", in: managedContext) else { return }
        var articlesCD = fetchAllArticles().sorted(by: { $0.id < $1.id } )
        let diff = articlesCD.count - array.count
        if diff > 0 {
            for article in articlesCD.dropFirst(articlesCD.count - diff) {
                managedContext.delete(article)
            }
            articlesCD = Array(articlesCD.dropFirst(articlesCD.count - diff))
        } else if diff < 0 {
            let newArticles = array[articlesCD.count...array.count - 1]
            _ = newArticles.map({ article in
                let model = ArticleCD(entity: entity, insertInto: managedContext)
                model.configure(withModel: article)
            })
        }
        _ = articles.map { article in
            for articleCD in articlesCD {
                if articleCD.id == article.id {
                    articleCD.configure(withModel: article)
                    continue
                }
            }
        }
        do {
            try managedContext.save()
        } catch {
            print("Error with saving courses to Core Data: \(error)")
        }
    }
    
    func saveGrammar(_ array: Array<Grammar>) {
        let grammars = array.sorted(by: { $0.id < $1.id } )
        guard let entity = NSEntityDescription.entity(forEntityName: "GrammarCD", in: managedContext) else { return }
        var grammarsCD = fetchAllGrammar().sorted(by: { $0.id < $1.id } )
        let diff = grammarsCD.count - array.count
        if diff > 0 {
            for grammar in grammarsCD.dropFirst(grammarsCD.count - diff) {
                managedContext.delete(grammar)
            }
            grammarsCD = Array(grammarsCD.dropFirst(grammarsCD.count - diff))
        } else if diff < 0 {
            let newGrammars = array[grammarsCD.count...array.count - 1]
            _ = newGrammars.map({ grammar in
                let model = GrammarCD(entity: entity, insertInto: managedContext)
                model.configure(withModel: grammar)
            })
        }
        _ = grammars.map { grammar in
            for grammarCD in grammarsCD {
                if grammarCD.id == grammar.id {
                    grammarCD.configure(withModel: grammar)
                    continue
                }
            }
        }
        do {
            try managedContext.save()
        } catch {
            print("Error with saving courses to Core Data: \(error)")
        }
    }
    
    func saveAchievements(_ array: Array<Achievement>) {
        let achievements = array.sorted(by: { $0.id < $1.id } )
        guard let entity = NSEntityDescription.entity(forEntityName: "AchievementCD", in: managedContext) else { return }
        var achievementsCD = fetchAllAchievements().sorted(by: { $0.id < $1.id } )
        let diff = achievementsCD.count - array.count
        if diff > 0 {
            for achievement in achievementsCD.dropFirst(achievementsCD.count - diff) {
                managedContext.delete(achievement)
            }
            achievementsCD = Array(achievementsCD.dropFirst(achievementsCD.count - diff))
        } else if diff < 0 {
            let newAchievements = array[achievementsCD.count...array.count - 1]
            _ = newAchievements.map({ achievement in
                let model = AchievementCD(entity: entity, insertInto: managedContext)
                model.configure(withModel: achievement)
            })
        }
        _ = achievements.map { achievement in
            for achievementCD in achievementsCD {
                if achievementCD.id == achievement.id {
                    achievementCD.configure(withModel: achievement)
                    continue
                }
            }
        }
        do {
            try managedContext.save()
        } catch {
            print("Error with saving courses to Core Data: \(error)")
        }
    }
    
    func saveLessons(_ array: Array<Lesson>) {
        let lessons = array.sorted(by: { $0.id < $1.id } )
        guard let entity = NSEntityDescription.entity(forEntityName: "LessonCD", in: managedContext) else { return }
        var lessonsCD = fetchAllLessons().sorted(by: { $0.id < $1.id } )
        let diff = lessonsCD.count - array.count
        if diff > 0 {
            for lesson in lessonsCD.dropFirst(lessonsCD.count - diff) {
                managedContext.delete(lesson)
            }
            lessonsCD = Array(lessonsCD.dropFirst(lessonsCD.count - diff))
        } else if diff < 0 {
            let newLessons = array[lessonsCD.count...array.count - 1]
            _ = newLessons.map({ lesson in
                let model = LessonCD(entity: entity, insertInto: managedContext)
                model.configure(withModel: lesson)
            })
        }
        _ = lessons.map { lesson in
            for lessonCD in lessonsCD {
                if lessonCD.id == lesson.id {
                    lessonCD.configure(withModel: lesson)
                    continue
                }
            }
        }
        do {
            try managedContext.save()
        } catch {
            print("Error with saving courses to Core Data: \(error)")
        }
    }
    
    //MARK: - Fetch
    func fetchAllCourses() -> Array<CourseCD> {
        do {
            let courses = try managedContext.fetch(coursesFetchRequest)
            return courses
        } catch let error as NSError {
            print("Could not fetch courses. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func fetchAllArticles() -> Array<ArticleCD> {
        do {
            let articles = try managedContext.fetch(articlesFetchRequest)
            return articles
        } catch let error as NSError {
            print("Could not fetch articles. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func fetchAllGrammar() -> Array<GrammarCD> {
        do {
            let grammar = try managedContext.fetch(grammarFetchRequest)
            return grammar
        } catch let error as NSError {
            print("Could not fetch grammar. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func fetchAllAchievements() -> Array<AchievementCD> {
        do {
            let achievements = try managedContext.fetch(achievementFetchRequest)
            return achievements
        } catch let error as NSError {
            print("Could not fetch achievements. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func fetchAllLessons() -> Array<LessonCD> {
        do {
            let lessons = try managedContext.fetch(lessonsFetchRequest)
            return lessons
        } catch let error as NSError {
            print("Could not fetch lessons. \(error), \(error.userInfo)")
            return []
        }
    }
    
    //MARK: - Delete all
    func deleteAllCourses() {
        let courses = fetchAllCourses()
        _ = courses.map({ course in
            managedContext.delete(course)
        })
    }
    
    func deleteAllArticles() {
        let articles = fetchAllArticles()
        _ = articles.map({ article in
            managedContext.delete(article)
        })
    }
    
    func deleteAllGrammar() {
        let grammar = fetchAllGrammar()
        _ = grammar.map({ grammar in
            managedContext.delete(grammar)
        })
    }
    
    func deleteAllAchievements() {
        let achievements = fetchAllAchievements()
        _ = achievements.map({ achievement in
            managedContext.delete(achievement)
        })
    }
    
    func deleteAllLessons() {
        let lessons = fetchAllLessons()
        _ = lessons.map({ lesson in
            managedContext.delete(lesson)
        })
    }
}
