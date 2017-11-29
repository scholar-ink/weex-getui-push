import GetuiPush from "../../js/src";

if (window.Weex) {
  Weex.install(GetuiPush);
} else if (window.weex) {
  weex.install(GetuiPush);
}