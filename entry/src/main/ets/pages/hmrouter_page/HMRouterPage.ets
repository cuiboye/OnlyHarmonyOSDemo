import { HMLifecycleState, HMPopInfo, HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { CommonHeader } from '../../common/common_header';
import { NavigationConstants } from '../../common/constants/NavigationConstants';

/**
 * HMRouter相关测试
 */
@HMRouter({ pageUrl: NavigationConstants.HMROUTER_PAGE })
@Component
export struct HMRouterPage {
  aboutToAppear(): void {
    //监听页面是否显示
    HMRouterMgr.getCurrentLifecycleOwner()?.addObserver(HMLifecycleState.onShown, () => {
      console.log('页面每次显示时调用一次')
    })
    //监听页面是否隐藏
    HMRouterMgr.getCurrentLifecycleOwner()?.addObserver(HMLifecycleState.onHidden, () => {
      console.log('页面每次隐藏时调用一次')
    })
  }

  build() {
    Column() {
      CommonHeader()
      Button('跳转下一个页面')
        .onClick(() => {
          //传递的参数是Map
          // let params:Map<string,string>=new Map()
          // params.set("tabsIndex","1");

          //传递的参数是interface
          let params:PersonParams = {
            personName: '张三',
            personAge:20
          }
          HMRouterMgr.push({ pageUrl: NavigationConstants.HMROUTERSECOND_PAGE, param:params})
        })
    }
    .height('100%')
    .width('100%')
  }
}

export interface PersonParams {
  personName: string;
  personAge:number
}