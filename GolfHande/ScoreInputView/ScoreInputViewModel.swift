import FirebaseDatabase

//struct ScoreData {
//    var courseRating: String = ""
//    var slopeRating: String = ""
//    var totalScore: String = ""
//}

class ScoreInputViewModel {

    private var database = Database.database().reference()
//    var scoreDatas = [ScoreData]

    var courseRating: String = ""
    var slopeRating: String = ""
    var totalScore: String = ""
    var courseName: String = ""
    var teePosition: String = ""

    /*
     Will overwrite data at specific location, including any child nodes.
     */
    func addScoreToDatabase() {
        let childString = "scores"
        let objectValue: [String: String] = [
            "courseRating": courseRating,
            "slopeRating": slopeRating,
            "totalScore": totalScore
        ]
        database.child(childString).child(UUID().uuidString).setValue(objectValue)
    }
}
