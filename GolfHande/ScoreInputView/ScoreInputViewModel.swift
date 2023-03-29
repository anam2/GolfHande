import FirebaseDatabase

class ScoreInputViewModel {

    private var ref = Database.database().reference()

    private let userChildString: String = NSLocalizedString("childString", comment: "childString")

    var courseRating: String = ""
    var slopeRating: String = ""
    var totalScore: String = ""
    var courseName: String = ""
    var teePosition: String = ""

    let golfCourses: [GolfCourseData]
    var selectedCourseID = ""

    var selectedCourse: GolfCourseData? {
        return getCourseData(for: selectedCourseID)
    }

    // MARK: INIT

    init(golfCourses: [GolfCourseData]) {
        self.golfCourses = golfCourses
    }

    func getCourseData(for courseID: String) -> GolfCourseData? {
        return golfCourses.first(where: { $0.id == courseID })
    }

    func calculateHandicap(courseID: String, userScore: String) -> String? {
        guard let userScore = Double(userScore),
              let courseData = self.getCourseData(for: courseID),
              let courseRating = Double(courseData.rating),
              let courseSlope = Double(courseData.rating)
        else { return nil }

        let numerator = (userScore - courseRating) * 113
        let denominator = courseSlope
        let handicap = round((numerator/denominator) * 10) / 10.0
        return "\(handicap)"
    }
    
    func getCurrentDateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        return dateFormatter.string(from: Date())
    }

    func intIsInbetween(range: ClosedRange<Int>, for num: String) -> Bool {
        guard let intNum = Int(num),
              range.contains(intNum) else { return false }
        return true
    }

    func doubleIsInbetween(range: ClosedRange<Double>, for num: String) -> Bool {
        guard let doubleNum = Double(num),
              range.contains(doubleNum) else { return false }
        return true
    }
}
