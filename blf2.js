var pack = zdjl.readFile('/sdcard/tool/pack.txt');
var lines = pack.split('\n');
function inputText(text) {
    zdjl.runActionAsync({
        type: "输入内容",
        delayUnit: 1,
        inputText: text,
        clearBeforeInput: true
    });
  }
function key(keyCode) {
    zdjl.runActionAsync({
        type: "按键",
        keyCode: keyCode
      });
}
for (var i = 0; i < lines.length; i++) {
    zdjl.sleep(3000);
    zdjl.toast(lines[i]);
    zdjl.runActionAsync({
        type: "打开应用",
        delayUnit: 1,
        appPackageName: lines[i],
        closeBeforeOpen: false,
        onlyClose: false
    });
    zdjl.sleep(2000);
    key(187);
    zdjl.sleep(2000);
    zdjl.click('6%', '50%')
    sleep(2000)
    zdjl.click('31%', '50%')
    zdjl.sleep(2000);
    key(4);
    zdjl.sleep(2000);
    zdjl.click('33%', '15%')
    zdjl.sleep(2000);
    zdjl.click('33%', '15%')
    zdjl.sleep(2000);
    inputText("blox fruit")
    zdjl.sleep(2000);
    zdjl.click('22%', '20%')
    zdjl.sleep(2000);
    zdjl.click('30%', '40%')
}
