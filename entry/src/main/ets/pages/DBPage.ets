/**
 * 数据库
 */
import KvManagerUtils from '../common/KvManagerUtils'
import { common } from '@kit.AbilityKit'
import { CommonHeader } from '../common/common_header'
type Success = (str:string)=>void

@Entry
@Component
export default struct DBPage{
  build() {
    Column(){
      CommonHeader({title:'数据库操作'})

      Button('kvManager数据库')
        .onClick(()=>{
          KvManagerUtils.init(getContext(this) as common.UIAbilityContext)
        })
    }
    .height('100%')
  }
}