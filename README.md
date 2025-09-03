1.HMRouter配置
1）安装插件
安装路由框架核心库
ohpm install @hadss/hmrouter
如需高级转场动画，安装转场动画库
ohpm install @hadss/hmrouter-transitions
2）修改工程根目录下的`hvigor/hvigor-config.json` 文件，加入路由编译插件
配置编译插件
```json5
{
  "dependencies": {
    "@hadss/hmrouter-plugin": "^1.2.0-rc.0"  // 使用npm仓版本号
  },
  // ...其余配置
}
```
3）修改工程根目录下的`hvigorfile.ts`，使用路由编译插件
```json5
import { appTasks } from '@ohos/hvigor-ohos-plugin';
import { appPlugin } from "@hadss/hmrouter-plugin";

export default {
system: appTasks,
plugins: [appPlugin({ ignoreModuleNames: [ /** 不需要扫描的模块 **/ ] })]
};
```
4）修改模块下的`hvigorfile.ts`
```json5
import { hapTasks } from '@ohos/hvigor-ohos-plugin';
import { hapPlugin } from '@hadss/hmrouter-plugin';

export default {
system: hapTasks,  
plugins:[hapPlugin()]  //module模块可能需要将hapPlugin()修改为modulePlugin()，没有试，遇到再说     
}
```
5）在项目下的build-profile.json5文件中添加“"useNormalizedOHMUrl": true”
```json5
"products": [
    {
        "name": "default",
        ...
        "buildOption": {
            "strictMode": {
              "useNormalizedOHMUrl": true,//添加这个，否则会报错
            },
        }
    },
]
```
6）在项目的根目录下创建hmrouter_config.json
```json5
{
  "scanDir": [
    "src/main/ets"
  ],
  "saveGeneratedFile": false
}
```
7）HMRouter是基于Navigation来实现的，需要在某个页面中配置下HMNavigation，可以参考InitPage