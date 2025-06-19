
/**
 * 自定义组件的使用
 */
@Component
export struct ComponentWidget{
  private title?:ResourceStr //ResourceStr为别名

  build(){
    Text(this.title)
  }
}