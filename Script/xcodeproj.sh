cd ../
swift package generate-xcodeproj
open ./Calatrava.xcodeproj
echo "Tips:"
echo "1. 编辑 module.modulemap. 设置你的真实头文件路径，例: /usr/local/mysql/include/mysql.h"
echo "2. Target -> PerfectMySQL -> Build Settings -> Library Search Paths 添加 /usr/local/mysql/lib"
echo "3. Target -> PjangoMySQL -> Build Settings -> Other Linker Flags 添加 -L/usr/local/mysql/lib"
