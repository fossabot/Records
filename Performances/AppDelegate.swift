import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let context = Storage.sharedInstance.persistentContainer.viewContext
        try! DataBuilder(context: context).populateDatabase()
        try! context.save()
        return true
    }
}
