## 假装看天气(Flutter) ##
该项目模仿Github的Android开源项目[**@假装看天气**](https://github.com/li-yu/FakeWeather)，整个项目完全通过Flutter进行开发，包括所有复杂的天气动画，同时该项目的所有架构和第三方库均在本人所在公司的线上项目实际使用中。

因为平时工作的原因，只是抽空断断续续的开发这个项目，目前还有一些还没有完善的地方，但是不影响正常使用。本人也会在日后继续进行该项目的维护。

如果喜欢的话记得点一波Star，使用中遇到任何BUG也欢迎提Issue

### 更新日志 ###
#### 重大更新： ####
+ 最近将项目适配了Flutter Web，现在可以切换至该项目web分支，再用最新的Flutter的master分支编译成web（因为爬取的数据源server有跨域问题，部分图片可能无法加载）。

#### 版本升级： ####
+ 2019-10-25(v1.3.1)：优化项目结构；部分自定义View重写了绘制逻辑，修复了波浪视图显示线条的BUG。
+ 2019-08-16(v1.3.0)：天气界面增加顶部多城市指示；妹子图看图优化；城市列表重写，使用了和风天气提供的城市；其他优化。
+ 2019-08-02(v1.2.2)：修复了妹子图部分分类网络请求失败问题（「妹子图」网站屏蔽了page为1的url...无语）；修复了获取更新时对时间的处理BUG。
+ 2019-07-19(v1.2.1)：优化妹子图看图体验，修复动态天气无法预览的BUG。Android项目迁移至AndroidX，并且寻找到了一个稳定的更新方案（app_version_service.dart中可查看）
+ 2019-06-20(v1.2.0)：天气分享功能已可正常使用（仿锤子便签/纯文本）；其他细节优化。
+ 2019-06-13(v1.1.3)：优化了查看妹子图时的Hero动画效果；新增了"设为壁纸"选项。

### 部分截图 ###
<img src="screenshot/1.jpg" width="24%"/><img width="1%"/><img src="screenshot/2.jpg" width="24%"/><img width="1%"/><img src="screenshot/3.jpg" width="24%"/><img width="1%"/><img src="screenshot/4.jpg" width="24%"/>
<img src="screenshot/5.jpg" width="24%"/><img width="1%"/><img src="screenshot/6.jpg" width="24%"/><img width="1%"/><img src="screenshot/7.jpg" width="24%"/><img width="1%"/><img src="screenshot/8.jpg" width="24%"/>

### 下载方式 ###
Android:<img src="qrcode/android.png"/>

IOS:没有开发者账号，暂时只能自己编译

### 编译环境 ###
目前已将项目迁移至AndroidX，Flutter版本信息如下：
```
[✓] Flutter (Channel beta, v1.7.8+hotfix.4-pre.5, on Mac OS X 10.14.5 18F132, locale zh-Hans-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 28.0.3)
[✓] Xcode - develop for iOS and macOS (Xcode 10.2.1)
[✓] iOS tools - develop for iOS devices
[✓] Android Studio (version 3.4)
[!] IntelliJ IDEA Community Edition (version 2018.2.1)
    ✗ Flutter plugin not installed; this adds Flutter specific functionality.
[✓] Connected device (1 available)
```

### 免责声明 ###
- 项目中图片素材大部分来自《假装看天气》，版权归属原作者，侵立删
- 整个项目仅供学习和交流使用，请勿未经允许私自商用！

### License ###
[Apache License
Version 2.0](https://github.com/hahafather007/flutter_weather/blob/master/LICENSE)
