### 前言
> 在软件工程中，**设计模式（Design Pattern）**是对软件设计中普遍存在（反复出现）的各种问题，所提出的解决方案。

> **策略模式（Strategy Pattern）**中定义一系列算法，并将每一个算法封装起来，使使它们可以相互替换，策略模式让算法独立于它的客户而变化。

下面我会就iOS实际开发中的case， 举例说明Strategy模式的在开发中的具体应用。

#### Case Study：
> 在开发中， 我们会遇到各种表单的提交需求， 在实际需求中，表单提交之前一般都需要检查一下所填写的数据的有效性。这些对于特定类型的数据的有效性检查，可能在程序中被反复用到。下面我就以开发中必不可少的用户登录功能，来看看Strategy模式的具体应用。


以email方式登录为例。你至少需要检查email和password输入的有效性。在修改email或者修改password时， 你又需要使用email和password数据有效性的检查逻辑。对于这种多于一次使用逻辑，基于**DRY（Don't Repeat Youself）**原则，我们需要封装起来。

![用户登录页面](http://upload-images.jianshu.io/upload_images/3712311-2b4a33255e158060.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 首先我们把检测数据的行为抽象一下，定义一个Validator Protocol。Validator我们可以称为策略的抽象
```
protocol Validator {
    func isValid(text: String?) -> Bool
}
```
* 有策略的抽象，那策略的实现在哪里。ok，实现来了。我们定义EmailValidator类，让它来实现Validator
```
class EmailValidator: Validator {
    func isValid(text: String?) -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        if let text = text {
            let entryTest = NSPredicate(format: "SELF MATCHES %@", regEx)
            return entryTest.evaluate(with: text)
        }
        return false
    }
}
```
* 另一个PasswordValidator类
```
class PasswordValidator: Validator {
    func isValid(text: String?) -> Bool {
        let regEx = "[A-Z0-9a-z._%+-;/><#]{6,30}"
        if let text = text {
            let entryTest = NSPredicate(format: "SELF MATCHES %@", regEx)
            return entryTest.evaluate(with: text)
        }
        return false
    }
}
```
* 这时候我们需要一个ValidatorManager来根据用户的条件，选择调用哪个策略的实现。
```
enum ValidationType: Int {
    case Email = 0
    case Password
}
class ValidationManager {
    
    private lazy var validators: [Validator] = [EmailValidator(), PasswordValidator()]
    
    func validationForText(text: String?, withValidationType validationType: ValidationType) -> Bool {
        return validators[validationType.rawValue].isValid(text: text)
    }
}
```
* 在LoginViewController具体的调用时这样子的：
```
    private lazy var validationManager = ValidationManager()
    @IBAction func tapLoginButton(_ sender: UIButton) {
        let emailValidation = validationManager.validationForText(text: emailField.text, withValidationType: .Email)
        let passValidation = validationManager.validationForText(text: passwordField.text, withValidationType: .Password)
        
        if emailValidation && passValidation {
            // Log in successfully and enter main view
            performSegue(withIdentifier: "ShowMainView", sender: self)
        } else {
            // validation failed. You can do anything you want to alert user.
            let alert = UIAlertController(title: "Failed", message: "Email or password is not valid.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
```

### 总结
* 第一步：你需要把你要做的事情抽象，用protocol来表示。 - 策略的抽象
* 第二步：你要做的事情在不同情况下肯定会有不同具体实现，创造不同类来实现你的protocol。 - 策略的具体实现
* 第三布：创建一个Manager来统一调配你的具体策略的实现。这个Manager会开放一个接口，满足你调用的最小充要条件。Manager会根据你的条件，决定具体使用什么策略。
* 最后一步：在你需要的地方使用Manager来实现你要做的事情吧。
