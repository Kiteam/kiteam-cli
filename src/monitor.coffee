_path = require 'path'
_forever = require 'forever-monitor'
_util = require './util'

exports.start = (workbench)->
  entry = _path.join workbench, 'index.js'

  return _util.quit '当前目录不是一个合法的Kiteam工作目录' if not _fs.existsSync entry


  child = new (_forever.Monitor)(entry, {
    max: 3,
    silent: true,
    args: []
  });

  child.on('exit', ->
    console.log('your-filename.js has exited after 3 restarts')
  )

  child.start()

exports.stop = ()->