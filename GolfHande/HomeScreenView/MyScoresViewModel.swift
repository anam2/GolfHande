import FirebaseDatabase

class MyScoresViewModel {

    private let database = Database.database().reference()

    var scoresData = [ScoreData]()
    var handicapArray = ["9", "+1", "49", "32", "4"]
}
