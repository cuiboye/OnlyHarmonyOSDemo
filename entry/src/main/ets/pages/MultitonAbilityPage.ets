/**
 * multiton启动模式,多实例模式
 */
import Want from '@ohos.app.ability.Want'
import common from '@ohos.app.ability.common'
@Entry
@Component
struct MultitonAbilityPage {
  private context = getContext(this) as common.UIAbilityContext

  aboutToAppear(){
    //这里接收的是在MultitonabilityEntryAbility中接收的want
    let want:Want =  globalThis.entryAbilityWant
    console.info("entryAbilityWant",want?.parameters?.instanceKey)
  }

  build() {
    Column() {
      Button(`启动新的Ability并接收返回的参数`).onClick(() => {
        let abilityResult:common.AbilityResult = {
          resultCode: 1001,
          want: {
            // bundleName: 'com.example.myapplication',
            bundleName: this.context.abilityInfo.bundleName,
            abilityName: 'EntryAbility',
            moduleName: 'entry',
            parameters: {
              backParams: '来自MultitonabilityEntryAbility',
            },
          },
        }
        // context为被调用方UIAbility的AbilityContext
        this.context.terminateSelfWithResult(abilityResult, (err) => {

        });
      })
    }
    .height('100%')
  }
}


//
// https://blog.csdn.net/m0_68349563/article/details/136605430
// https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/application-model-description-0000001493584092-V2