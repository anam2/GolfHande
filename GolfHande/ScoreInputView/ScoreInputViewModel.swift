import FirebaseDatabase

class ScoreInputViewModel {

    private var ref = Database.database().reference()

    private let userChildString: String = NSLocalizedString("childString", comment: "childString")

    var courseRating: String = ""
    var slopeRating: String = ""
    var totalScore: String = ""
    var courseName: String = ""
    var teePosition: String = ""

    func calculateHandicap(userScore: String,
                           courseRating: String,
                           courseSlope: String) -> String? {
        guard let userScore = Double(userScore),
              let courseRating = Double(courseRating),
              let courseSlope = Double(courseSlope) else { return nil }
        let numerator = (userScore - courseRating) * 113
        let denominator = courseSlope
        let handicap = round((numerator/denominator) * 10) / 10.0
        return "\(handicap)"
    }
}
