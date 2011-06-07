fs = require 'fs'
{spawn, exec} = require 'child_process'

stdio = process.binding("stdio")
fds = [stdio.stdinFD, stdio.stdoutFD, stdio.stderrFD]

run = (cmd) ->
    exec cmd, (err, stdout, stderr) ->
        console.log stdout.trim() if stdout
        console.log stderr.trim() if stderr

task 'build', 'build NuMUD', ->
    run 'coffee -c -o lib src/'

task 'build:watch', 'watch NuMUD source files for changes and automatically rebuild', ->
    proc = spawn 'coffee', ['-w', '-c', '-o', 'lib', 'src/'], { customFds: fds }
