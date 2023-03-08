import FirebaseDatabase

class MyScoresViewModel {

    private let database = Database.database().reference()

    var scoresData = [ScoreData]()
    var handicapArray = ["9", "+1", "49", "32", "4"]

    func fetchScores(completion: @escaping (Bool) -> Void) {
        ServiceCalls.getScores { allScoreData in
            guard let allScoreData = allScoreData else {
                completion(false)
                return
            }
            for scoreData in allScoreData {
                if !self.scoresData.contains(where: { $0.scoreId == scoreData.scoreId}) {
                    self.scoresData.append(scoreData)
                }
            }
            self.scoresData = self.scoresData.sorted(by: { $0.dateTimeAdded > $1.dateTimeAdded })
            completion(true)
        }
    }
}
