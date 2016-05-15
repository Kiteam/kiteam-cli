_fs = require('fs-extra')
_path = require('path')
_ = require 'lodash'
_util = require './util'

GIT_SITE = 'https://github.com/kiteam/'
GIT_TEMP = '.kiteam_repos'

#检查目标目录是否存在，不存在则创建， 并检查是否非空
ensureTarget = (target)->
  if not _fs.existsSync target
    _fs.ensureDirSync target
    return true

  #目录已经存在，则检查目录是否非空
  return true if _fs.readdirSync(target).length is 0
  _util.quit '目录非空，安装失败，请检查是否有隐藏文件'

#确保环境正常
ensureEnv = (target)->
  return _util.quit '检测到您没有安装git，请先安装git' if not which('git')

  #目标目录有问题
  ensureTarget target

copyFile = (tempDir, moduleName, sourceName, target, targetName)->
  targetName = sourceName if targetName is undefined
  console.log "正在复制#{sourceName} -> #{targetName}"

  source = _path.join tempDir, moduleName, sourceName
  target = _path.join target, targetName
  _fs.copySync source, target

#从服务器上clone并安装
install = (target)->
  tempDir = _path.join target, GIT_TEMP
  _fs.ensureDirSync tempDir

  clientName = 'kiteam-angular'
  apiName = 'kiteam'

  #clone仓库并构建
  cloneAndBuild clientName, tempDir
  cloneAndBuild apiName, tempDir

  #复制api
  copyFile tempDir, apiName, 'lib', target
  #复制node_modules
  copyFile tempDir, apiName, 'node_modules', target
  #复制api/package.json
  copyFile tempDir, apiName, 'package.json', target
  #复制静态文件
  copyFile tempDir, clientName, '.dest', target, 'static'

  #复制完成， 清除临时目录
  console.log '清除临时目录'
#  _fs.removeSync tempDir

executeCommand = (command)->
  console.log "执行[#{command}]， 请稍候..."
  #执行npm run build
  execResult = exec command
#  console.log execBuild.stdout
#  console.log execBuild.stderr

  _util.quit "执行[#{command}]失败，请检查错误信息".red if execResult.code isnt 0

#clone仓库到本地
cloneAndBuild = (repo_name, tempDir, npm)->
  npm = npm || 'cnpm'
  cd tempDir
#  executeCommand "git clone #{GIT_SITE}#{repo_name}.git"

  console.log "#{repo_name} clone成功，正在安装..."
  #切换到工作目录
  workbench = _path.join tempDir, repo_name
  cd workbench

  #install and bild
  executeCommand "#{npm} install --verbose"
  executeCommand "#{npm} run build"

#执行初始化项目
module.exports = (name, target)->
  target = _path.join target, name if name
  #return process.exit 1 if not ensureEnv target

  install target