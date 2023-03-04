import FirebaseDatabase

struct ScoreData {
    var courseName: String
    var totalScore: Int
    var slopeRating: Int
    var courseRating: Double
}

class MainViewModel {

    private let database = Database.database().reference()

    var allScores = [[String: String]]()

    var scoresData = [ScoreData]()
    /*
     Fetches all scores from DB and populates `scoreData`.
     */
    func getScoresFromDatabase(completion: @escaping () -> Void) {
        database.child("scores").observeSingleEvent(of: .value) { snapshot in
            guard let scoresDictionary = snapshot.value as? [String : AnyObject] else { return }
            var allScores = [[String: String]]()
            for value in scoresDictionary {
                let test: [String: String]? = value.value as? [String: String]
                allScores.append(test ?? [:])
            }
            self.parseSnapShotToScoreData(allScores: allScores)
            completion()
        }
    }

    private func parseSnapShotToScoreData(allScores: [[String: String]]) {
        for currentScore in allScores {
            guard let courseRating = currentScore["courseRating"],
                  let slopeRating = currentScore["slopeRating"],
                  let totalScore = currentScore["totalScore"],
                  let courseName = currentScore["courseName"] else { return }
            let newScoreData = ScoreData(courseName: courseName,
                                         totalScore: Int(totalScore) ?? 0,
                                         slopeRating: Int(slopeRating) ?? 0,
                                         courseRating:  Double(courseRating) ?? 0.0)
            scoresData.append(newScoreData)
        }
    }
}
