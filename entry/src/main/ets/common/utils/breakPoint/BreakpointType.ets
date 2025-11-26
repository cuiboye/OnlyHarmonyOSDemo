import { BreakpointConstants } from "./BreakpointConstants";
import { display } from "@kit.ArkUI";

export class BreakpointType<T> {
  static currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM
  sm: T;
  md: T;
  lg: T;

  constructor(sm: T, md: T, lg: T) {
    this.sm = sm;
    this.md = md;
    this.lg = lg;
  }

  getValue(currentBreakpoint: string): T {
    if (currentBreakpoint === BreakpointConstants.BREAKPOINT_MD) {
      return this.md;
    }
    if (currentBreakpoint === BreakpointConstants.BREAKPOINT_LG) {
      return this.lg;
    } else {
      return this.sm;
    }
  }

  static updateBreakpoint(windowWidth: number): void {
    let windowWidthVp = windowWidth / display.getDefaultDisplaySync().densityPixels;
    let curBp: string = '';
    if (windowWidthVp < BreakpointConstants.BREAKPOINT_SCOPE[2]) {
      curBp = BreakpointConstants.BREAKPOINT_SM;
    } else if (windowWidthVp < BreakpointConstants.BREAKPOINT_SCOPE[3]) {
      curBp = BreakpointConstants.BREAKPOINT_MD;
    } else {
      curBp = BreakpointConstants.BREAKPOINT_LG;
    }
    AppStorage.setOrCreate('currentBreakpoint', curBp);
  }
}

