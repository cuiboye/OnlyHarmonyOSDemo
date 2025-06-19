import AbilityStage from '@ohos.app.ability.AbilityStage';
import Want from '@ohos.app.ability.Want';

/**
 * 处理specified类型的启动模式
 */
export default class MyAbilityStage extends AbilityStage {
  onAcceptWant(want: Want): string {
    if(want.abilityName === 'MultitonabilityEntryAbility'){
      //instanceKey需要和跳转Ability中的parameters的参数一致
      return want.parameters.instanceKey.toString()
    }
    return ''
  }
}