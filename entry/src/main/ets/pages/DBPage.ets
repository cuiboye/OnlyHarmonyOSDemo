import KvManagerUtils from '../common/KvManagerUtils'
import { common } from '@kit.AbilityKit'
import { CommonHeader } from '../common/common_header'
import { NavigationConstants } from '../common/constants/NavigationConstants'
import { HMRouter } from '@hadss/hmrouter'

type Success = (str:string)=>void
/**
 * 数据库
 */
@HMRouter({ pageUrl: NavigationConstants.DB_PAGE })
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