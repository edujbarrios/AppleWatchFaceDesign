import WatchKit
import Foundation
import UserNotifications

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var notificationCountLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        updateClock()
        updateDate()
        updateNotificationCount()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateDate), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationCount), name: NSNotification.Name(rawValue: "NotificationCountUpdated"), object: nil)
    }
    
    override func willActivate() {
        super.willActivate()
        // Update the notification count when the app becomes active
        updateNotificationCount()
    }
    
    @objc func updateClock() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let currentTime = formatter.string(from: Date())
        timeLabel.setText(currentTime)
    }
    
    @objc func updateDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let currentDate = formatter.string(from: Date())
        dateLabel.setText(currentDate)
    }
    
    @objc func updateNotificationCount() {
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            DispatchQueue.main.async {
                self.notificationCountLabel.setText("\(notifications.count)")
            }
        }
    }
}

