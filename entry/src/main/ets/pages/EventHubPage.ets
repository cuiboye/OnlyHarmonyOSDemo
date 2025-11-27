import { HMRouter } from '@hadss/hmrouter'
import { AppUtils } from '../common/AppUtils'
import { CommonHeader } from '../common/common_header'
import { NavigationConstants } from '../common/constants/NavigationConstants'
import promptAction from '@ohos.promptAction'
import { EventDispatcher } from '../common/utils/EventDispatcher'
import { ToastUtils } from '../common/utils/ToastUtils'

/**
 * EventHub和Emitter的使用
 */
@HMRouter({ pageUrl: NavigationConstants.EVENTHUB_PAGE })
@Component
export struct EventHubPage {

  aboutToAppear(): void {
    //接收消息
    AppUtils.getContext().eventHub.on('BUILDERPARAM_PAGE', (entity: EventHubEntity) => {
      promptAction.showToast({ message: `name is ${entity.name ?? ''},age is ${entity.age ?? 0}` })
    })

    //使用Emitter监听消息
    EventDispatcher.addEvent('communityItemIsLike', (params: EmitterLikeParams) => {
      if (!params) {
        return
      }
      ToastUtils.show(`likeCount is ${params.likeCount}`)
    })
  }

  aboutToDisappear(): void {
    EventDispatcher.removeEvent('communityItemIsLike')
  }

  build() {
    Column() {
      CommonHeader()
      Button('使用EventHub发送消息')
        .onClick(()=>{
          let entity:EventHubEntity = new EventHubEntity()
          entity.name = '张三'
          entity.age = 20
          //发送消息
          AppUtils.getContext().eventHub.emit('BUILDERPARAM_PAGE',entity)//entity为EventHub传递的数据
        })
      Button('使用Emitter发送消息')
        .onClick(()=>{
          let ls:EmitterLikeParams = {
            'likeCount': 100,
          }
          EventDispatcher.sendEvent('communityItemIsLike', ls)
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

export interface EmitterLikeParams {
  likeCount:number
}
