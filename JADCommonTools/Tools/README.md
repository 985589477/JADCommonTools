# JADTools
定义常用的工具类
# ScreenFix
用于定义屏幕适配的一些代码
### 示例
```
ScreenFix.basicMode = .iphone375 || .iphone414

ScreenFix(100).value
ScreenFix(100).rawValue.floatValue

//获得自适应屏幕后的比例宽高
let (width, height) = ScreenFix.scaling(100, 200)
```
# JADLanguage && JADDynamic
国际化的工具类
### 示例
```
需要提前在AppDelegate中设置 JADLanguage.initialize(默认语言，不设置也可以)
JADLanguage.key("国际化key")
如果有App内选择语言，可以对 JADLanguage扩展，文件内有参考代码
切换语言有通知App内监听 JADLanguage.JADLanguageChangedNotification
切换文字有通知App内监听 JADDynamicDidChanged
该两种通知，都可以触发DynamicText的动作，之所以设置两个，是因为DynamicText包括不限于国际化

DynamicText 
场景1  UILabel文字切换
    label.dynamicText = JADDynamicText({ _ in JADLanguage.key("dynamicText") })
    label.dynamicText = JADDynamicText({ (language) -> String in
        if language == .english {
            return "我是英文"
        } else {
            return "我是中文"
        }
    })
场景2  UIImageView图片切换

场景3  网络请求切换
本场景由开发者自行实现，可以在base里提供 JADLanguage.JADLanguageChangedNotification 的监听实现网络请求切换
```

# UIColor+JADCategory
颜色的十六进制转换
adapterColor方法
示例
```
参考颜色定义 adapterColor方法用于适配iOS13主题色
class JADColor {
    static var contentColor: JADColorAdapter = { (trait) -> UIColor in
        if #available(iOS 12.0, *) {
            if trait?.userInterfaceStyle == .dark {
                return UIColor.yellow
            }
        }
        return UIColor.red
    }
}

imageView.backgroundColor = UIColor.adapterColor(JADColor.contentColor)

```

# UITableView+JADCategory
baseSettings 配置tableView基本设置，基本上都要写这些

# UIView+JADCategory
设置圆角
corners(conrners: UIRectCorner , radius: CGFloat)

# UIScreen+JADCategory
关于屏幕的一些简写

# UITextField+Rules
定义输入框的规则，比如限制长度等等

示例
```
首先需要定义一个策略类，实现validate方法，此方法需要配置满足什么条件才算校验通过
其次给textField设置规则，可以同时设置多个规则
最后当textField中有文字的时候，调用validate()方法即可判定输入框内的文本是否符合规则
class PhoneBitStorage: UITextFieldStrategy {
    func validate(with: UITextField) -> Bool {
        return true
    }
}
textField.rules = [PhoneBitStorage()]
let isValidate = textField.validate()

```

# UIImage+JADCategory
定义了处理图片的方法 包括:
通过颜色生成图片
压缩图片
生成图片二维码
生成图片条形码

# Array+JADCategory
removeDuplicates 元素去重

# UIDevice+JADCategroy
获取设备字符串

# String+JADCategory
字符串截取
```

let string = "fisrtString"
print(string[1,4]) //log "isr"

print(string.subString(range: Range(uncheckedBounds: (1,4)))) //log "isr"
 
```

时间戳转换 p1: 格式 p2 级别，毫秒或者秒 
timeFormatterWithTimestamp(dateFormatter: String, level: JADTimestampLevel? = .ms)   

base64加密
base64解密


# Form
可扩展性的表单组件
### JADFormConfiguration
用于定义表单的配置 以及存储表单的样式 section  row

### JADFormBaseCell
所有展示在表单内的cell都继承于他

### JADFormTableView
展示在界面的表单列表控件

示例
```
let configuration = MKFormConfiguration(style: .plain)
let formView = MKFormTableView(config: configuration)
let section = MKFormSection()

let row = MKFormRow(cell: JADFormBaseCell()) 注意:这里的cell绑定的是你定义的子类cell
row.extraData = cell绑定的模型数据
row.rowHeight = 72
//此方法作为绑定事件 .load事件相当于cellForRowAtIndexPath方法 event则为事件回调的闭包
row.registerEvent(status: .load, event: rowModel.getCellLoadEvent())
//相当于tableView didSelected方法
row.registerEvent(status: .didSelected, event: xxxxxx)

section.addRow(row: row)
configuration.addSection(section: section)

```

# JADBannerView
轮播图
示例
```
let configuration = MKBannerViewConfiguration()
configuration.timeInterval = 1.5
let layout = MKBannerViewLayout()
layout.itemSize = CGSize(width: 339.fix, height: 339.fix / (375 / 104))
configuration.layout = layout
bannerView = MKBannerView(config: configuration)
bannerView.frame = CGRect(x: 0, y: 0, width: 20, height: 108)
bannerView.backgroundColor = UIColor.clear
bannerView.isTimerEnabled = false
self.addSubview(bannerView)
```

# JADNavigation
定义导航头部，导航View 需要遵守 MKNavigationAPI 协议
JADDefaultNavigation为示例

# JADWebView
加载外部链接，简便了js交互方法

# JADWindowViewController &  JADMaskView
用来定义弹窗的蒙层

# JADProgressView
进度条view

# JADButton
可以设置背景渐变、文字渐变、边框渐变

# JADAnyScrollTableView
主要作用于两个tableView联动手势冲突问题，这个是包裹在最外层的tableView，可以让add在其上面的tableView都可以接受到滑动手势

# JADScrollSegmentView
超过屏幕可以滑动的栏目控制view，类似网易新闻
必须设置 behaviorDelegate
可选设置 delegate

# JADImagePicker
图片选择器

```
let picker = JADImagePicker()
picker.open(sourceType: .camera) || picker.open(sourceType: .photoLibrary)
picker.result = { (result) in
    result.originalImage
    result.editedImage
    result.info
}
```
### JADImagePhotosConfiguration
可以针对JADImagePicker 的 相机功能配置

### JADImageLibraryConfiguration
可以针对JADImagePicker 的 相册功能配置

只需要在JADImagePicker构造时候传入,对哪个有非默认设置的修改传入哪个
JADImagePicker(photos: , library: )

