import mediaQuery from '@ohos.mediaquery';
/**
 * 多屏幕适配工具类
 */
interface MediaQueryResult {
  matches: boolean
}

export default class BreakpointSystem {
  private currentBreakpoint: string = 'sm'
  private smListener: mediaQuery.MediaQueryListener = {} as mediaQuery.MediaQueryListener
  private mdListener: mediaQuery.MediaQueryListener = {} as mediaQuery.MediaQueryListener
  private lgListener: mediaQuery.MediaQueryListener = {} as mediaQuery.MediaQueryListener

  private updateCurrentBreakpoint(breakpoint: string) {
    if (this.currentBreakpoint !== breakpoint) {
      this.currentBreakpoint = breakpoint
      AppStorage.Set<string>('currentBreakpoint', this.currentBreakpoint)
    }
  }

  private isBreakpointSM = (mediaQueryResult: MediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.updateCurrentBreakpoint('sm')
      AppStorage.Set<number>('fontSize', 14)
      AppStorage.Set<number>('coverMargin', 10)
    }
  }
  private isBreakpointMD = (mediaQueryResult: MediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.updateCurrentBreakpoint('md')
      AppStorage.Set<number>('fontSize', 16)
      AppStorage.Set<number>('coverMargin', 30)
    }
  }
  private isBreakpointLG = (mediaQueryResult: MediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.updateCurrentBreakpoint('lg')
      AppStorage.Set<number>('fontSize', 18)
      AppStorage.Set<number>('coverMargin', 40)
    }
  }

  public register() {
    this.smListener = mediaQuery.matchMediaSync('(320vp<=width<520vp)')
    this.smListener.on('change', this.isBreakpointSM)
    this.mdListener = mediaQuery.matchMediaSync('(520vp<=width<840vp)')
    this.mdListener.on('change', this.isBreakpointMD)
    this.lgListener = mediaQuery.matchMediaSync('(840vp<=width)')
    this.lgListener.on('change', this.isBreakpointLG)
  }

  public unregister() {
    this.smListener.off('change', this.isBreakpointSM)
    this.mdListener.off('change', this.isBreakpointMD)
    this.lgListener.off('change', this.isBreakpointLG)
  }
}