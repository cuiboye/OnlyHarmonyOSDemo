import router from '@ohos.router'
import { CommonHeader } from '../../common/common_header'
@Entry
@Component
struct AnimateMainPage {
  @State message: string = 'Hello World'
  @State message2: string = 'Hello World'

  build() {
    Column() {
      CommonHeader({title:'动画'})
      Button('显示动画')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/animate/display_animate_page'
          })
        })
      Button('属性动画')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/animate/attribute_animate_page'
          })
        })
      Button('共享元素转场动画')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/animate/shared_animate_page'
          })
      })
      Button('页面之间的转场动画')
        .onClick(()=>{
          router.pushUrl({
            url:'pages/animate/PageTransition'
          })
        })
      Button('列表中的共享元素转场动画')
        .onClick(() => {
          router.pushUrl({
            url: 'pages/animate/ShareListPage'
          })
        })

      Button('test')
        .onClick(()=>{
          // this.message2 = undefined
          // this.message2 = null
          // console.log(`this.message2: ${this.message2}`)
          // console.log(`this.message2.length: ${this.message2.length}`)

          // let result = this.message2 ?? '999'
          // console.log(`this.result: ${result}`)

          this.message2 ??= 'hello'
          console.log(`this.result1: ${this.message2}`)
        })
    }
    .height('100%')
  }
}
