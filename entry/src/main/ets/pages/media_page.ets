import mediaquery from '@ohos.mediaquery';
import hilink from '@ohos.hiTraceChain';
import window from '@ohos.window';

/**
 * 媒体查询-多屏幕适配
 */
@Entry
@Component
struct MediaPage {
  @State message: string = 'Hello World'

  aboutToAppear(){
    //1)导包
    //2)设置媒体查询条件，并获取对应的listener
    let listener = mediaquery.matchMediaSync('(320vp<=width<600vp)')
    //3)给listener设置回调函数，当设备状态变化时会执行回调函数
    listener.on('change',result=>{
      //判断是否满足查询条件
      if(result.matches){
        //记录当前设备状态
      }
    })
    //4)将设备信息记录到全局状态中
    AppStorage.SetOrCreate('currentBreakpoint','SM')
    //获取AppStorage中的值
    // @StorageProp('currentBreakpoint') currentBreakpoint :String = 'SM'

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