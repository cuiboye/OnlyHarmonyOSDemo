import { CommonHeader } from '../../common/common_header'

/**
 * 组件内转场动画，可以实现Dialog/底部弹框的效果
 */
@Entry
@Component
struct ComponentTransitionPage {
  @State show: boolean = false

  build() {
    Stack() {
      Column() {
        CommonHeader({ title: '组件内转场动画' })
        Button('组件内转场动画，可以实现Dialog/底部弹框的效果')
          .onClick(() => {
            animateTo({ duration: 600 }, () => {
              this.show = !this.show
            })
          })
      }
      .backgroundColor('#00a0e9')
      .height('100%')


      if(this.show){
        Column() {
          Row().layoutWeight(1).width('100%')
          .onClick(()=>{
            animateTo({ duration: 600 }, () => {
              this.show = false
            })
          })
          Column() {
            Text('Hello').fontSize(20)
          }.backgroundColor('#ffffff').width('100%').height(50)
        }.width('100%').height('100%').justifyContent(FlexAlign.End)
        // 组件添加时从底部滑出，透明度从0到1.0
        .transition({ type: TransitionType.Insert, translate: { x: 0, y: 50, z: 0 }, opacity: 1.0 })
        // 组件移除时沿x轴旋转180度
        .transition({ type: TransitionType.Delete, translate: { x: 0, y:50, z: 0 },opacity: 0.0 } )
      }
    }
    .height('100%')
  }
}