# SQCache
- A lightweight, pure-Swift library for cache framework in iOS.
- 轻量、纯Swift内存缓存库，For iOS。

单元测试
==============
- 内含单元测试代码。
- 跑通所有类和方法的单元测试。
- 代码覆盖率在95%以上。
![Memory cache Test](https://github.com/aloow/SQCache/blob/master/memorycacheTest.png?raw=true)

特性
==============
- **LRU**: 缓存支持 LRU (least-recently-used) 淘汰算法。
- **缓存控制**: 支持多种缓存控制方法：总数量、总大小、存活时间、空闲空间。
- **兼容性**: API 基本和 `NSCache` 保持一致, 所有方法都是线程安全的。
- **内存缓存**
  - **对象释放控制**: 对象的释放(release) 可以配置为同步或异步进行，可以配置在主线程或后台线程进行。
  - **自动清空**: 当收到内存警告或 App 进入后台时，缓存可以配置为自动清空。
>PS:暂时只支持内存缓存，后续添加支持磁盘缓存


安装
==============

### CocoaPods

1. 在 Podfile 中添加 `pod 'SQCache'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 `import SQCache`

### 手动安装

1. 下载 SQCache 文件夹内的所有内容。
2. 将 SQCache 内的源文件添加(拖放)到你的工程。
3. 链接以下的 frameworks:
	* UIKit
	* Foundation


系统要求
==============
该项目最低支持 `iOS 9.0` 和 `Xcode 10.0`。


许可证
==============
SQCache 使用 MIT 许可证，详情见 LICENSE 文件。
