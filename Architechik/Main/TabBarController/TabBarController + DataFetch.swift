//
//  TabBarController + DataFetch.swift
//  Architechik
//
//  Created by Александр Цветков on 07.02.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

extension TabBarController {
    
    func fetchData() {
        fetchFromDevice()
        fetchCourses()
    }
    
    //MARK: - Fetch from server
    private func fetchCourses() {
        NetworkDataFetcher.shared.fetchCourses { courses in
            if courses.count != 0 {
                self.coursesVC.models = courses.sorted(by: { $0.id < $1.id } )
                DataManager.shared.saveCourses(courses)
            }
            self.fetchLessons()
        }
    }
    
    private func fetchLessons() {
        NetworkDataFetcher.shared.fetchCourseStructure { lessons in
            if lessons.count != 0 {
                self.coursesVC.lessons = lessons
                DataManager.shared.saveLessons(lessons)
            }
            self.fetchArticles()
        }
    }
    
    private func fetchArticles() {
        NetworkDataFetcher.shared.fetchArticles { articles in
            if articles.count != 0 {
                self.articlesVC.models = articles.sorted(by: { $0.id > $1.id } )
                DataManager.shared.saveArticles(articles)
            }
            self.fetchGrammar()
        }
    }
    
    private func fetchGrammar() {
        NetworkDataFetcher.shared.fetchGrammar { grammar in
            if grammar.count != 0 {
                self.grammarVC.models = grammar.sorted(by: { $0.id < $1.id } )
                DataManager.shared.saveGrammar(grammar)
            }
            self.fetchAchievements()
        }
    }
    
    private func fetchAchievements() {
        NetworkDataFetcher.shared.fetchAchievments { achievements in
            if achievements.count != 0 {
                self.profileVC.models = achievements.sorted(by: { $0.id < $1.id } )
                DataManager.shared.saveAchievements(achievements)
            }
        }
    }
    
    //MARK: - Fetch from device
    private func fetchFromDevice() {
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
        coursesVC.models = courses
    }
    
    private func fetchLessonsFromDevice() {
        let lessonsCD = DataManager.shared.fetchAllLessons()
        var lessons: Array<Lesson> = []
        _ = lessonsCD.map { lessonCD in
            lessons.append(Lesson(fromModel: lessonCD))
        }
        coursesVC.lessons = lessons
    }
    
    private func fetchArticlesFromDevice() {
        let articlesCD = DataManager.shared.fetchAllArticles()

        var articles: Array<Article> = []
        _ = articlesCD.map { articleCD in
            articles.append(Article(fromModel: articleCD))
        }
        articlesVC.models = articles
    }
    
    private func fetchGrammarFromDevice() {
        let grammarsCD = DataManager.shared.fetchAllGrammar()

        var grammars: Array<Grammar> = []
        _ = grammarsCD.map { grammarCD in
            grammars.append(Grammar(fromModel: grammarCD))
        }
        grammarVC.models = grammars
    }
    
    private func fetchAchievementsFromDevice() {
        let achievementsCD = DataManager.shared.fetchAllAchievements()
        var achievements: Array<Achievement> = []
        _ = achievementsCD.map { achievementCD in
            achievements.append(Achievement(fromModel: achievementCD))
        }
        profileVC.models = achievements
    }

}
