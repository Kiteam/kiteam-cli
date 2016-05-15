
#退出并提出警告
exports.quit = (log)->
  console.log log.red
  process.exit 1