import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var toggle:Bool = true
    
    @IBOutlet weak var whiteView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        whiteView.alpha = 0.0
    }
    
    @IBAction func buttonTapped(sender : AnyObject) {
        if(toggle){
            ledFlash(flg: true)
            toggle = false
            
        }
        else{
            ledFlash(flg: false)
            toggle = true
        }
    }
    
    func ledFlash(flg: Bool){
        
        let avDevice = AVCaptureDevice.default(for: AVMediaType.video)!
        
        if avDevice.hasTorch {
            do {
                // torch device lock on
                try avDevice.lockForConfiguration()
                
                if (flg){
                    // flash LED ON
                    avDevice.torchMode = AVCaptureDevice.TorchMode.on
                    whiteView.alpha = 1.0
                } else {
                    // flash LED OFF
                    avDevice.torchMode = AVCaptureDevice.TorchMode.off
                    whiteView.alpha = 0.0
                }
                
                // torch device unlock
                avDevice.unlockForConfiguration()
                
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    @IBAction func SliderChanged(_ sl: UISlider){
        let level = Float(sl.value)
        if let avDevice = AVCaptureDevice.default(for: AVMediaType.video){
            
            if avDevice.hasTorch {
                do {
                    // torch device lock on
                    try avDevice.lockForConfiguration()
                    
                    if (level > 0.0){
                        do {
                            try avDevice.setTorchModeOn(level: level)
                            whiteView.alpha = CGFloat(level)
                        } catch {
                            print("error")
                        }
                        
                    } else {
                        // flash LED OFF
                        // 注意しないといけないのは、0.0はエラーになるのでLEDをoffさせます。
                        avDevice.torchMode = AVCaptureDevice.TorchMode.off
                    }
                    // torch device unlock
                    avDevice.unlockForConfiguration()
                    
                } catch {
                    print("Torch could not be used")
                }
            } else {
                print("Torch is not available")
            }
        }
        else{
            // no support
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


@IBDesignable class BorderButton : UIButton {
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
