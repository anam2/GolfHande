struct UserScoreData {
    var courseID: String?
    var score: String
    var handicap: String

    init(courseID: String? = nil, score: String, handicap: String) {
        self.courseID = courseID
        self.score = score
        self.handicap = handicap
    }

    init?(scoreDataDict: [String: String]) {
        guard let courseID = scoreDataDict["courseID"],
              let userScore = scoreDataDict["score"],
              let handicap = scoreDataDict["handicap"]
        else { return nil }
        // Sets values for UserScoreData from snapshot data.
        self.courseID = courseID
        self.score = userScore
        self.handicap = handicap
    }
}
