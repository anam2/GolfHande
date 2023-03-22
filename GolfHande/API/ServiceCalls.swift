import FirebaseDatabase

class ServiceCalls {
    private static let ref = Database.database().reference()

    static func readScores(completion: @escaping (_: [UserScoreData]?) -> Void) {
        let scoresRef = ref.child("scores")
        var scoresArray = [UserScoreData]()

        scoresRef.observeSingleEvent(of: .value) { scoresSnapshotData in
            guard let scoreDict = scoresSnapshotData.value as? [String: Any] else {
                completion([])
                return
            }
            for (key, value) in scoreDict {
                guard let currentScoreDict = value as? [String: String],
                      let userScoreData = UserScoreData(scoreID: key, scoreDataDict: currentScoreDict)
                else {
                    completion(nil)
                    return
                }
                scoresArray.append(userScoreData)
            }
            completion(scoresArray)
        }
    }

    static func readAllCourses(completion: @escaping (_: [GolfCourseData]?) -> Void) {
        let coursesRef = ref.child("courses")
        var coursesArray = [GolfCourseData]()

        coursesRef.observeSingleEvent(of: .value) { coursesSnapshotData in
            guard let courseDict = coursesSnapshotData.value as? [String: Any] else { return }
            for (key, value) in courseDict {
                guard let courseDataDict = value as? [String: String],
                      let courseData = GolfCourseData(courseID: key, courseDataDict: courseDataDict)
                else {
                    completion(nil)
                    return
                }
                coursesArray.append(courseData)
            }
            completion(coursesArray)
        }
    }

    /**
    Makes a service call and fetches a specific golf course.
     - parameter courseID: [String] The courseID of the course you want to find.
     - parameter completion: [ (GolfCourseData?) -> Void ] Going to pass in the golf course data.
     */
    static func readSpecificCourse(courseID: String, completion: @escaping (GolfCourseData?) -> Void) {
        let coursesRef = ref.child("courses")
        coursesRef.observeSingleEvent(of: .value) { snapshotData in
            guard let coursesDict = snapshotData.value as? [String: Any],
                  let specificCourseDict = coursesDict[courseID] as? [String: String],
                  let specificCourse = GolfCourseData(courseID: courseID,
                                                      courseDataDict: specificCourseDict)
            else {
                completion(nil)
                return
            }
            completion(specificCourse)
        }
    }

    /**
     Adds user score AND golf course data to firebase.
     - parameter score: [String] The user's score they shot.
     - parameter courseData: [GolfCourseDataModel] The golf course data the user played at.
     */
    static func addScore(userScoreData: UserScoreData, courseData: GolfCourseData) {
        let courseRef = ref.child("courses").child(courseData.id)
        let scoresRef = ref.child("scores").child(userScoreData.id)

        let courseRefValues: [String: String] = [
            "name": courseData.name,
            "rating": courseData.rating,
            "slope": courseData.slope
        ]

        let scoreRefValues: [String: String] = [
            "courseID": courseData.id,
            "dateAdded": userScoreData.dateAdded,
            "score": userScoreData.score,
            "handicap": userScoreData.handicap
        ]

        courseRef.setValue(courseRefValues)
        scoresRef.setValue(scoreRefValues)
    }

    static func deleteScore(for scoreID: String,
                            completion: @escaping ( Bool) -> Void) {
        let scoreIDRef = ref.child("scores").child(scoreID)
        scoreIDRef.observeSingleEvent(of: .value) { snapshot in
            snapshot.ref.removeValue()
            completion(true)
        }
    }
}
