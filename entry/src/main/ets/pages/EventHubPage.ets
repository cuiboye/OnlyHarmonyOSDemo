import { HMRouter } from '@hadss/hmrouter'
import { AppUtils } from '../common/AppUtils'
import { CommonHeader } from '../common/common_header'
import { NavigationConstants } from '../common/constants/NavigationConstants'
import promptAction from '@ohos.promptAction'

/**
 * EventHub工具的使用
 */
@HMRouter({ pageUrl: NavigationConstants.EVENTHUB_PAGE })
@Component
export struct EventHubPage {

  aboutToAppear(): void {
    //接收消息
    AppUtils.getContext().eventHub.on('BUILDERPARAM_PAGE', (entity: EventHubEntity) => {
      promptAction.showToast({ message: `name is ${entity.name ?? ''},age is ${entity.age ?? 0}` })
    })
  }

  build() {
    Column() {
      CommonHeader()
      Button('发送EventHub')
        .onClick(()=>{
          let entity:EventHubEntity = new EventHubEntity()
          entity.name = '张三'
          entity.age = 20
          //发送消息
          AppUtils.getContext().eventHub.emit('BUILDERPARAM_PAGE',entity)//entity为EventHub传递的数据
        })
    }
    .height('100%')
    .width('100%')
  }
}

class EventHubEntity{
  name?:string
  age?:number
}
