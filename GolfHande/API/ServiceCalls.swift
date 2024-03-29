import FirebaseDatabase
import FirebaseAuth

class ServiceCalls {
    static let shared = ServiceCalls()
    private let ref: DatabaseReference

    private let coursesRef: DatabaseReference
    private let scoresRef: DatabaseReference
    let usersRef: DatabaseReference

//    private static let coursesParam = "courses"
//    private static let scoresParam = "scores"

    private init() {
        ref = Database.database().reference()
        coursesRef = ref.ref.child("courses")
        scoresRef = ref.ref.child("scores")
        usersRef = ref.ref.child("users")
    }

    // MARK: READ

    func readScores(completion: @escaping (_: [UserScoreData]?) -> Void) {
        let userID = Auth.auth().currentUser?.uid ?? ""
        var scoresArray = [UserScoreData]()
        let userScoresQuery = scoresRef.queryOrdered(byChild: "userID").queryEqual(toValue: userID)

        userScoresQuery.observeSingleEvent(of: .value) { snapshot in
            guard let scoresDict = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            for (key, value) in scoresDict {
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

    func readAllCourses(completion: @escaping (_: [GolfCourseData]?) -> Void) {
//        let coursesRef = ref.child("courses")
        var coursesArray = [GolfCourseData]()

        coursesRef.observeSingleEvent(of: .value) { coursesSnapshotData in
            guard let courseDict = coursesSnapshotData.value as? [String: Any]
            else {
                completion(nil)
                return
            }
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
    func readSpecificCourse(courseID: String, completion: @escaping (GolfCourseData?) -> Void) {
//        let coursesRef = ref.child("courses")
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

    // MARK: ADD

    /**
     Adds user score AND golf course data to firebase.
     - parameter score: [String] The user's score they shot.
     - parameter courseData: [GolfCourseDataModel] The golf course data the user played at.
     */
    func addScore(userScoreData: UserScoreData) {
        let userUID = Auth.auth().currentUser?.uid ?? ""
        let scoresRef = scoresRef.child(userScoreData.id)
        let scoreRefValues: [String: String] = [
            "userID": userUID,
            "courseID": userScoreData.courseID,
            "dateAdded": userScoreData.dateAdded,
            "score": userScoreData.score,
            "handicap": userScoreData.handicap
        ]
        scoresRef.setValue(scoreRefValues)
    }

    func addCourse(courseData: GolfCourseData, completion: @escaping (Bool) -> Void) {
        let courseRef = coursesRef.child(courseData.id)
        let courseRefValues: [String: String] = [
            "name": courseData.name,
            "rating": courseData.rating,
            "slope": courseData.slope
        ]
        courseRef.setValue(courseRefValues)
        completion(true)
    }

    // MARK: EDIT

    func editScore(selectedScoreData: SelectedScoreInput,
                   updatedHandicapValue: String) {
        scoresRef.child(selectedScoreData.scoreID).updateChildValues([
            // TODO: Need to add a `Date Edited` field.
            "courseID": selectedScoreData.courseID,
            "handicap": updatedHandicapValue,
            "score": selectedScoreData.userScore
        ])
    }

    // MARK: DELETE

    func deleteScore(for scoreID: String,
                            completion: @escaping (Bool) -> Void) {
        let scoreIDRef = ref.child("scores").child(scoreID)
        scoreIDRef.observeSingleEvent(of: .value) { snapshot in
            snapshot.ref.removeValue()
            completion(true)
        }
    }

    func deleteCourse(for courseID: String,
                             completion: @escaping (Bool) -> Void) {
        let courseIDRef = ref.child("courses").child(courseID)
        courseIDRef.observeSingleEvent(of: .value) { snapshot in
            snapshot.ref.removeValue()
            completion(true)
        }
    }
}
