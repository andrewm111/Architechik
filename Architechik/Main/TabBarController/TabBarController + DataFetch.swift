//
//  TabBarController + DataFetch.swift
//  Architechik
//
//  Created by Александр Цветков on 07.02.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import Network

extension TabBarController {
    
    func fetchData() {
        fetchFromDevice()
        fetchCourses()
    }
    
    //MARK: - Fetch from server
    func fetchCourses() {
        NetworkDataFetcher.shared.fetchCourses { courses in
            if !courses.isEmpty {
                self.timesFetchCoursesCalled += 1
                self.coursesVC.models = courses.sorted(by: { $0.id < $1.id } )
                DataManager.shared.saveCourses(courses)
            } else {
                self.timesFetchCoursesCalled += 1
                if self.timesFetchCoursesCalled < 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.fetchCourses()
                    }
                } else {
                    self.timesFetchCoursesCalled = 0
                }
            }
            if self.timesFetchCoursesCalled == 1 {
                self.fetchLessons()
            }
            if !courses.isEmpty { self.timesFetchCoursesCalled = 0 }
        } // NetworkDataFetcher
    }
    
    private func fetchLessons() {
        NetworkDataFetcher.shared.fetchCourseStructure { lessons in
            if !lessons.isEmpty {
                self.timesFetchLessonsCalled += 1
                self.coursesVC.lessons = lessons
                DataManager.shared.saveLessons(lessons)
                
            } else {
                self.timesFetchLessonsCalled += 1
                if self.timesFetchLessonsCalled < 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.fetchLessons()
                    }
                } else { self.timesFetchLessonsCalled = 0 }
            }
            if self.timesFetchLessonsCalled == 1 {
                self.fetchArticles()
            }
            if !lessons.isEmpty { self.timesFetchLessonsCalled = 0 }
        } // NetworkDataFetcher
    }
    
    private func fetchArticles() {
        NetworkDataFetcher.shared.fetchArticles { articles in
            if !articles.isEmpty {
                self.timesFetchArticlesCalled += 1
                self.articlesVC.models = articles
                DataManager.shared.saveArticles(articles)
                
            } else {
                self.timesFetchArticlesCalled += 1
                if self.timesFetchArticlesCalled < 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.fetchArticles()
                    }
                } else { self.timesFetchArticlesCalled = 0 }
            }
            if self.timesFetchArticlesCalled == 1 {
                self.fetchGrammar()
                if !articles.isEmpty { self.timesFetchArticlesCalled = 0 }
            }
        } // NetworkDataFetcher
    }
    
    private func fetchGrammar() {
        NetworkDataFetcher.shared.fetchGrammar { grammar in
            if !grammar.isEmpty {
                self.timesFetchGrammarCalled += 1
                self.grammarVC.models = grammar.sorted(by: { $0.id < $1.id } )
                DataManager.shared.saveGrammar(grammar)
                
            } else {
                self.timesFetchGrammarCalled += 1
                if self.timesFetchGrammarCalled < 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.fetchGrammar()
                    }
                } else { self.timesFetchGrammarCalled = 0 }
            }
            if self.timesFetchGrammarCalled == 1 {
                self.fetchAchievements()
                if !grammar.isEmpty { self.timesFetchGrammarCalled = 0 }
            }
        } // NetworkDataFetcher
    }
    
    private func fetchAchievements() {
        //NotificationCenter.default.post(name: NSNotification.Name("ShowServerAlert"), object: nil, userInfo: ["title": "Error", "text": "Server error"])
        NetworkDataFetcher.shared.fetchAchievments { achievements in
            if !achievements.isEmpty {
                self.timesFetchGrammarCalled += 1
                self.profileVC.models = achievements.sorted(by: { $0.id < $1.id } )
                DataManager.shared.saveAchievements(achievements)
                
            } else {
                self.timesFetchAchievementsCalled += 1
                if self.timesFetchAchievementsCalled < 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.fetchAchievements()
                    }
                } else { self.timesFetchAchievementsCalled = 0 }
            }
        } // NetworkDataFetcher
        //NotificationCenter.default.post(name: NSNotification.Name("CreateMonitor"), object: nil)
    }
    
    //MARK: - Fetch from device
    func fetchFromDevice() {
        fetchCoursesFromDevice()
        fetchLessonsFromDevice()
        fetchArticlesFromDevice()
        fetchGrammarFromDevice()
        fetchAchievementsFromDevice()
    }
    
    private func fetchCoursesFromDevice() {
        let coursesCD = DataManager.shared.fetchAllCourses()
        var courses: Array<Course> = []
        _ = coursesCD.map { courseCD in
            courses.append(Course(fromModel: courseCD))
        }
        if !courses.isEmpty { coursesVC.models = courses }
    }
    
    private func fetchLessonsFromDevice() {
        let lessonsCD = DataManager.shared.fetchAllLessons()
        var lessons: Array<Lesson> = []
        _ = lessonsCD.map { lessonCD in
            lessons.append(Lesson(fromModel: lessonCD))
        }
        if !lessons.isEmpty { coursesVC.lessons = lessons }
    }
    
    private func fetchArticlesFromDevice() {
        let articlesCD = DataManager.shared.fetchAllArticles()
        
        var articles: Array<Article> = []
        _ = articlesCD.map { articleCD in
            articles.append(Article(fromModel: articleCD))
        }
        if !articles.isEmpty { articlesVC.models = articles }
    }
    
    private func fetchGrammarFromDevice() {
        let grammarsCD = DataManager.shared.fetchAllGrammar()
        
        var grammars: Array<Grammar> = []
        _ = grammarsCD.map { grammarCD in
            grammars.append(Grammar(fromModel: grammarCD))
        }
        if !grammars.isEmpty { grammarVC.models = grammars }
    }
    
    private func fetchAchievementsFromDevice() {
        let achievementsCD = DataManager.shared.fetchAllAchievements()
        var achievements: Array<Achievement> = []
        _ = achievementsCD.map { achievementCD in
            achievements.append(Achievement(fromModel: achievementCD))
        }
        if !achievements.isEmpty {
            profileVC.models = achievements
        }
    }
    
}
