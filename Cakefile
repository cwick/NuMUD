fs = require 'fs'
{spawn, exec} = require 'child_process'

stdio = process.binding("stdio")
fds = [stdio.stdinFD, stdio.stdoutFD, stdio.stderrFD]

run = (cmd) ->
    exec cmd, (err, stdout, stderr) ->
        console.log stdout.trim() if stdout
        console.log stderr.trim() if stderr
        if err
            process.exit err.code

task 'build', 'build NuMUD', ->
    run 'coffee -c -o bin src/'

task 'build:watch', 'watch NuMUD source files for changes and automatically rebuild', ->
    proc = spawn 'coffee', ['-w', '-c', '-o', 'bin', 'src/'], { customFds: fds }

task 'runserver', 'Start the NuMUD server', ->
    proc = spawn 'node', ['bin/server.js'], { customFds: fds }
