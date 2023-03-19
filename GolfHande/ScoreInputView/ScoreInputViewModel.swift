import FirebaseDatabase

class ScoreInputViewModel {

    private var ref = Database.database().reference()

    private let userChildString: String = NSLocalizedString("childString", comment: "childString")

    var courseRating: String = ""
    var slopeRating: String = ""
    var totalScore: String = ""
    var courseName: String = ""
    var teePosition: String = ""
}
