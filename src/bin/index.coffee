#!/usr/bin/env coffee

require 'colors'
require 'shelljs/global'
_program = require('commander')
_path = require('path')

_create = require '../create'
_monitor = require '../monitor'

_version = require(_path.join(__dirname, '../../package.json')).version


#######################################安装kiteam#########################################
#安装Kiteam
_program.command('init [name]')
.option('-t, --target', '指定安装目标目录')
.option('-n, --npm', '指定npm的安装命令，如tnpm')
.description('安装Kiteam')
.action((name, program)->
  _create name, program.target || process.cwd(), program.npm
)

#卸载插件
_program.command('start')
.description('启动Kiteam')
.option('-p, --port', '指定端口')
.option('-s, --source', '指定源文件的目录')
.action((program)->
  source = program.source || process.cwd()
  _monitor.start source, program.port
)

#列出插件
_program.command('stop')
.description('停止Kiteam的服务')
.action((program)->
  _monitor.stop process.cwd()
)

#版本和描述
versionDesc = "Version: #{_version}"
_program.version(versionDesc).parse(process.argv)
