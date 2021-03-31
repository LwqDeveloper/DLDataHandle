# DLDataHandle

### NSUserDefaults缺点
#### 1.不能统计保存的key值，容易产生垃圾数据
#### 2.每次都要手动save

### DLUserDefaultsModel改进
#### 1.自定义model继承自DLUserDefaultsModel，添加属性清晰可见
#### 2.属性使用 @dynamic 调用runtime替换方法 ，自动sava
