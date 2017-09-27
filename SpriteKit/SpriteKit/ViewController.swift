//
//  ViewController.swift
//  SpriteKit
//
//  Created by Vianka Barboza on 9/25/17.
//  Copyright © 2017 Vianka Barboza. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    let activityManager = CMMotionActivityManager();
    let pedometer = CMPedometer();
    let motion = CMMotionManager()
    let userDefaults = UserDefaults.standard
    var totalSteps: Float = 0.0 {
        willSet(newtotalSteps){
            DispatchQueue.main.async{
                self.stepLable.text = "Steps: \(newtotalSteps)"
                self.userDefaults.set(newtotalSteps, forKey: "steps")
            }
        }
    }
    let calendar = Calendar.current
    var twoDaysAgo = Date();
    let steps = ["1000", "2000", "3000", "4000", "5000", "6000", "7000", "8000", "9000", "10000"]
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var stepLable: UILabel!
    @IBOutlet weak var movementLable: UILabel!
    @IBOutlet weak var goalPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let userDefaults = UserDefaults.standard
        self.totalSteps = 0.0
        goalPicker.delegate = self
        goalPicker.dataSource = self
        self.startActivityMonitoring()
        self.startPedometerMonitoring()
        
        if userDefaults.value(forKey: "goals") != nil
        {
            self.goalLabel.text = "Current Goal: " + userDefaults.string(forKey: "goals")!
            
        }
        else // no preference was found so we set a default value
        {
            userDefaults.set("0", forKey: "goals")
            userDefaults.synchronize()
        }
        
        // if we find a preference for "measurementType" then read its value
        if userDefaults.value(forKey: "steps") != nil
        {
            self.stepLable.text = "Current Goal: \(userDefaults.float(forKey: "steps"))"
        }
        else // no preference was found so we set a default value
        {
            userDefaults.set("0", forKey: "steps")
            userDefaults.synchronize()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return steps.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return steps[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let goal = steps[goalPicker.selectedRow(inComponent: component)]
        self.userDefaults.set(goal, forKey: "goals")
        updateGoalLabel()
        
    }
    
    func updateGoalLabel() {
        self.goalLabel.text = "Current Goal: " + userDefaults.string(forKey: "goals")!
    }
    
    // MARK: Activity Functions
    func startActivityMonitoring(){
        // is activity is available
        if CMMotionActivityManager.isActivityAvailable(){
            // update from this queue (should we use the MAIN queue here??.... )
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: self.handleActivity)
        }
        
    }
    
    
    func handleActivity(_ activity:CMMotionActivity?)->Void{
        // unwrap the activity and disp
        if let unwrappedActivity = activity {
            DispatchQueue.main.async{
                if unwrappedActivity.walking == true {
                    self.movementLable.text = "Movement: Walking"
                }
                else if unwrappedActivity.running == true{
                    self.movementLable.text = "Movement: Running"
                }
                else if unwrappedActivity.cycling == true{
                    self.movementLable.text = "Movement: Cycling"
                }
                else if unwrappedActivity.stationary == true{
                    self.movementLable.text = "Movement: Still"
                }
                else if unwrappedActivity.automotive == true{
                    self.movementLable.text = "Movement: Driving"
                }
                else if unwrappedActivity.unknown == true{
                    self.movementLable.text = "Movement: Uknown"
                }
            }
        }
    }
    
    // MARK: Pedometer Functions
    func startPedometerMonitoring(){
        self.twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())!
        //separate out the handler for better readability
        if CMPedometer.isStepCountingAvailable(){
            pedometer.startUpdates(from: twoDaysAgo,
                                   withHandler: handlePedometer)
        }
    }
    
    //ped handler
    func handlePedometer(_ pedData:CMPedometerData?, error:Error?)->(){
        if let steps = pedData?.numberOfSteps {
            self.totalSteps = steps.floatValue
        }
    }


}

