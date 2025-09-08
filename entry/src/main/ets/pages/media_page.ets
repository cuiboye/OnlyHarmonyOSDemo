import { HMRouter } from '@hadss/hmrouter';
import mediaquery from '@ohos.mediaquery';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import BreakpointSystem from '../common/MediaData';

/**
 * 媒体查询-多屏幕适配
 */
@HMRouter({ pageUrl: NavigationConstants.MEDIA_PAGE })
@Component
export struct MediaPage {
  @State message: string = 'Hello World'
  private breakpointSystem: BreakpointSystem = new BreakpointSystem()

  aboutToAppear(){
    //1)导包
    //2)设置媒体查询条件，并获取对应的listener
    // let listener = mediaquery.matchMediaSync('(320vp<=width<600vp)')
    // //3)给listener设置回调函数，当设备状态变化时会执行回调函数
    // listener.on('change',result=>{
    //   console.log(`this result is ${JSON.stringify(result)}`);
    //   //判断是否满足查询条件
    //   if(result.matches){
    //     //记录当前设备状态
    //   }
    // })
    // //4)将设备信息记录到全局状态中
    // AppStorage.SetOrCreate('currentBreakpoint','SM')
    // //获取AppStorage中的值
    // // @StorageProp('currentBreakpoint') currentBreakpoint :String = 'SM'

    this.breakpointSystem.register()
  }

  aboutToDisappear() {
    //取消屏幕监听
    this.breakpointSystem.unregister()
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}