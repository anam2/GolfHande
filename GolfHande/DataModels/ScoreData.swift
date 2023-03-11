import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore

struct ScoreData {
    var scoreId: String
    var courseName: String
    var totalScore: String
    var courseSlope: String
    var courseRating: String
    var dateTimeAdded: Date = Date()

    var dateAdded: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yy"
        return dateFormatter.string(from: dateTimeAdded)
    }

    static func parseSnapShotToScoreData(scoreId: String, allScores: [String: Any]) -> ScoreData? {
        guard
            let timeStamp = allScores["dateTimeAdded"] as? Int,
            let courseRating = allScores["courseRating"] as? String,
            let slopeRating = allScores["slopeRating"] as? String,
            let totalScore = allScores["totalScore"] as? String,
            let courseName = allScores["courseName"] as? String
        else { return nil }

        let newScoreData = ScoreData(scoreId: scoreId,
                                     courseName: courseName,
                                     totalScore: totalScore,
                                     courseSlope: slopeRating,
                                     courseRating: courseRating,
                                     dateTimeAdded: Date(timeIntervalSince1970: TimeInterval(timeStamp)/1000))
        return newScoreData
    }
}
