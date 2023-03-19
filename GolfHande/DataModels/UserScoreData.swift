struct UserScoreData {
    var courseID: String
    var score: String

    init(courseID: String, score: String) {
        self.courseID = courseID
        self.score = score
    }

    init?(scoreDataDict: [String: String]) {
        guard let courseID = scoreDataDict["courseID"],
              let userScore = scoreDataDict["score"]
        else { return nil }
        // Sets values for UserScoreData from snapshot data.
        self.courseID = courseID
        self.score = userScore
    }
}
