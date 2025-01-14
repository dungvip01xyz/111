function inputText(text) {
  zdjl.runActionAsync({
      type: "输入内容",
      delayUnit: 1,
      inputText: text,
      clearBeforeInput: true
  });
}
sleep(1000)
zdjl.runActionAsync({
  type: "按键",
  keyCode:187
});
sleep(1000)
zdjl.click('50%', '6%')
sleep(1000)
zdjl.click('50%', '32%')
sleep(1000)
zdjl.click('33%', '15%')
sleep(1000)
zdjl.click('33%', '15%')
inputText("blox fruit")
sleep(1000)
zdjl.click('22%', '20%')
sleep(1000)
zdjl.click('30%', '40%')
