import FirebaseDatabase

class ScoreInputViewModel {

    private var database = Database.database().reference()

    var courseRating: String = ""
    var slopeRating: String = ""
    var totalScore: String = ""
    var courseName: String = ""
    var teePosition: String = ""

    /*
     Will overwrite data at specific location, including any child nodes.
     */
    func addScoreToDatabase(scoreData: ScoreData) {
        let childString = "scores"
        let objectValue: [String: String] = [
            "courseRating": scoreData.courseRating,
            "slopeRating": scoreData.slopeRating,
            "totalScore": scoreData.totalScore,
            "courseName": scoreData.courseName
        ]
        database.child(childString).child(UUID().uuidString).setValue(objectValue)
    }
}
