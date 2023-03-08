struct ScoreData {
    var scoreId: String
    var courseName: String
    var totalScore: String
    var slopeRating: String
    var courseRating: String

    static func parseSnapShotToScoreData(scoreId: String, allScores: [String: String]) -> ScoreData? {
        guard let courseRating = allScores["courseRating"],
              let slopeRating = allScores["slopeRating"],
              let totalScore = allScores["totalScore"],
              let courseName = allScores["courseName"]
        else { return nil }

        let newScoreData = ScoreData(scoreId: scoreId,
                                     courseName: courseName,
                                     totalScore: totalScore,
                                     slopeRating: slopeRating,
                                     courseRating:  courseRating)
        return newScoreData
    }
}
