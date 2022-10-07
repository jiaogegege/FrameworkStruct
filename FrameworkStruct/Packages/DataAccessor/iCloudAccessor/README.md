#  iCloud存取器

用于在iCloud间同步数据和保存信息

说明：
NSUbiquitousKeyValueStore 最大的存储容量为 1MB（每个用户），存储的键值对不得超过 1024 对。
苹果并不推荐使用 NSUbiquitousKeyValueStore 保存数据量大、变化频繁且对 app 运行至关重要的数据。

iCloud文件保存服务
