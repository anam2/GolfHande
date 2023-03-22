struct UserScoreData {
    var id: String
    var courseID: String
    var dateAdded: String
    var score: String
    var handicap: String

    init(id: String,
         courseID: String,
         dateAdded: String,
         score: String,
         handicap: String) {
        self.id = id
        self.courseID = courseID
        self.dateAdded = dateAdded
        self.score = score
        self.handicap = handicap
    }

    init?(scoreID: String, scoreDataDict: [String: String]) {
        guard let courseID = scoreDataDict["courseID"],
              let dateAdded = scoreDataDict["dateAdded"],
              let userScore = scoreDataDict["score"],
              let handicap = scoreDataDict["handicap"]
        else { return nil }
        // Sets values for UserScoreData from snapshot data.
        self.id = scoreID
        self.courseID = courseID
        self.dateAdded = dateAdded
        self.score = userScore
        self.handicap = handicap
    }
}
