import Foundation

struct ScoreInputDataModel {
    let golfCourses: [GolfCourseData]
    var selectedScoreData: SelectedScoreInput?
}

struct SelectedScoreInput {
    var scoreID: String = ""
    var courseID: String = ""
    var userScore: String = ""
}

class ScoreInputViewModel {
    var dataModel: ScoreInputDataModel
    private let userChildString: String = NSLocalizedString("childString", comment: "childString")

    var selectedCourse: GolfCourseData? {
        guard let selectedScoreInput = dataModel.selectedScoreData else { return nil }
        return getCourseData(for: selectedScoreInput.courseID)
    }

    // MARK: INIT

    init(_ dataModel: ScoreInputDataModel) {
        self.dataModel = dataModel
    }

    func getCourseData(for courseID: String) -> GolfCourseData? {
        guard let selectedScoreInput = dataModel.selectedScoreData else { return nil }
        return dataModel.golfCourses.first(where: { $0.id == selectedScoreInput.courseID })
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
