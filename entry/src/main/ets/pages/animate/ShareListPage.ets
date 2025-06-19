import router from '@ohos.router'
import curves from '@ohos.curves'
import { CommonHeader } from '../../common/common_header'
/**
 * 列表中的共享元素转场动画
 */
@Entry
@Component
struct ShareListPage {
  @State message: string = 'Hello World'
  imageArray: Resource[] = [
    $r('app.media.share1'),
    $r('app.media.share2'),
    $r('app.media.share3'),
    $r('app.media.share4'),
    $r('app.media.share5'),
    $r('app.media.share6'),
  ]

  build() {
    Column() {
      CommonHeader({ title: '操作列表中的共享元素动画' })
      Grid() {
        ForEach(this.imageArray, (item: Resource,index:number) => {
          GridItem() {
            Image(item)
              .width(120)
              .aspectRatio(1)
              .sharedTransition(index.toString(),{duration:600,curve:Curve.Smooth,delay:100})
              .onClick(()=>{
                router.pushUrl({
                  url:'pages/animate/ShareListSecondPage',
                  params:{index:index}
                })
              })
          }
        })
      }
      .columnsGap(10)
      .rowsGap(10)
      .columnsTemplate('1fr 1fr 1fr')
    }
    .height('100%')
  }
}