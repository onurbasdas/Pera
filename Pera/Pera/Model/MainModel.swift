//
//  MainModel.swift
//  Pera
//
//  Created by Onur on 19.01.2024.
//

import Foundation

struct MainModel: Codable {
    var id: Int?
    var nodeID, name, fullName: String?
    var welcomePrivate: Bool?
    var htmlURL: String?
    var description: String?
    var fork: Bool?
    var url, forksURL: String?
    var keysURL, collaboratorsURL: String?
    var teamsURL, hooksURL: String?
    var issueEventsURL: String?
    var eventsURL: String?
    var assigneesURL, branchesURL: String?
    var tagsURL: String?
    var blobsURL, gitTagsURL, gitRefsURL, treesURL: String?
    var statusesURL: String?
    var languagesURL, stargazersURL, contributorsURL, subscribersURL: String?
    var subscriptionURL: String?
    var commitsURL, gitCommitsURL, commentsURL, issueCommentURL: String?
    var contentsURL, compareURL: String?
    var mergesURL: String?
    var archiveURL: String?
    var downloadsURL: String?
    var issuesURL, pullsURL, milestonesURL, notificationsURL: String?
    var labelsURL, releasesURL: String?
    var deploymentsURL: String?
    var createdAt, updatedAt, pushedAt: Date?
    var gitURL, sshURL: String?
    var cloneURL: String?
    var svnURL: String?
    var homepage: String?
    var size, stargazersCount, watchersCount: Int?
    var language: String?
    var hasIssues, hasProjects, hasDownloads, hasWiki: Bool?
    var hasPages, hasDiscussions: Bool?
    var forksCount: Int?
    var archived, disabled: Bool?
    var openIssuesCount: Int?
    var allowForking, isTemplate, webCommitSignoffRequired: Bool?
    var visibility: String?
    var forks, openIssues, watchers: Int?
    var defaultBranch: String?
    var isFavoriteKey: String {
        return "FavoriteStatus_\(id ?? 1)"
    }
}
