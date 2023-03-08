import FirebaseDatabase

class ServiceCalls {

    private static let database = Database.database().reference()

    static func getScores(completion: @escaping(_: [ScoreData]) -> Void) {
        database.child("scores").observeSingleEvent(of: .value) { snapshot in
            guard let scoresDictionary = snapshot.value as? [String : AnyObject] else { return }

            var totalScores = [ScoreData]()
            for value in scoresDictionary {
                let scoreId = value.key
                guard let scoreData = value.value as? [String: String],
                      let newScoreData = ScoreData.parseSnapShotToScoreData(scoreId: scoreId,
                                                                       allScores: scoreData) else { return }
                totalScores.append(newScoreData)
            }
            completion(totalScores)
        }
    }

}
