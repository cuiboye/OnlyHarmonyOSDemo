import { HMLifecycleState, HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { CommonHeader } from '../../common/common_header';
import { NavigationConstants } from '../../common/constants/NavigationConstants';
import { PersonParams } from './HMRouterPage';

/**
 * HMRouter第二个页面
 */
@HMRouter({ pageUrl: NavigationConstants.HMROUTERSECOND_PAGE })
@Component
export struct HMRouterSecondPage {
  aboutToAppear(): void {
    //接收HMRouter传递过来的参数（这里接收的是Map，参数可以是任意类型）
    // let params = HMRouterMgr.getCurrentParam() as Map<string, string>
    // if (params) {
    //   let result = params.get('tabsIndex')
    //   console.log(`this result is ${result}`)
    // }

    //接收的参数是接口
    let params = HMRouterMgr.getCurrentParam() as PersonParams
    let personName = params.personName
    let personAge = params.personAge
    console.log(`this personName is ${personName},this personAge is ${personAge}`)
  }

  build() {
    Column() {
      CommonHeader({title:'我是第二个页面'})
      Button('返回')
        .onClick(()=>{
          HMRouterMgr.pop()
        })
      Button('返回动上一个页面并携带参数')
        .onClick(()=>{
          //pop中的参数是任意类型ESObject
          // HMRouterMgr.pop({param:20})//参数是number类型
          HMRouterMgr.pop({ param: { name: "张三", age: 20 } })
        })
      Button('返回到某个页面并销毁中间所有的页面')
        .onClick(()=>{
          HMRouterMgr.pop({pageUrl:NavigationConstants.INDEX_PAGE})
        })
    }
    .height('100%')
    .width('100%')
  }
}