/**
 * ListView的自定义footer
 */
import { LoadMoreLayoutStatus, LoadMoreLayoutStatusModel } from '@abner/refresh_v2'

@Component
export struct CustomFooterLayoutView {
  status?: LoadMoreLayoutStatusModel

  build() {
    if (this.status?.status === LoadMoreLayoutStatus.Pulling) {
      Row()
    } else if (this.status?.status === LoadMoreLayoutStatus.Release) {
      Text('我是自定义footer')
    } else if (this.status?.status === LoadMoreLayoutStatus.Loading) {
      Text('我是自定义footer')
    } else if (this.status?.status === LoadMoreLayoutStatus.Finish ||
      this.status?.status === LoadMoreLayoutStatus.FooterNothing) {
      Row()
    }
  }
}