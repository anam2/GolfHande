struct GolfCourseData {
    var id: String
    var name: String
    var rating: String
    var slope: String

    init(id: String,
         name: String,
         rating: String,
         slope: String) {
        self.id = id
        self.name = name
        self.rating = rating
        self.slope = slope
    }

    init?(courseID: String, courseDataDict: [String: String]) {
        guard let courseName = courseDataDict["name"],
              let courseRating = courseDataDict["rating"],
              let courseSlope = courseDataDict["slope"]
        else { return nil }
        // Sets vale for GolfCourseData from snapshot data.
        self.id = courseID
        self.name = courseName
        self.rating = courseRating
        self.slope = courseSlope
    }
}
