const $fs = require('fs')
const $path = require('path')
const $yaml = require('js-yaml')
const conf = '/etc/infrastructure'

function files(path, results, matches, filter) {
  results = results || []

  var entries = $fs.readdirSync(path)
  for (var index = 0; index < entries.length; index++) {
    var entry = entries[index]
    var resolved = $path.join(path, entry)
    var entryStat = $fs.lstatSync(resolved)
    if (entryStat && entryStat.isDirectory()) {
      files(resolved, results, matches)
    } else {
      var extension = $path.extname(entry)
      var name = $path.basename(entry, extension)
      if (!matches || (matches && matches.indexOf(extension) >= 0)) {
        if (filter) {
          var filtered = filter(name, extension, resolved)
          if (filtered) {
            results.push(filtered)
          }
        } else {
          results.push(resolved)
        }
      }
    }
  }
}

$fs.lstat(conf, function (err, stat) {
  if (err || !stat.isDirectory()) {
    console.log('Infrastructure conf not available.')
    process.exit(1)
  }

  files(conf, undefined, ['.composer'],
    function (name, extension, path) {
      // Parse the JSON file.
      var contents = $fs.readFileSync(path).toString()
      var json = JSON.parse(contents)

      // Create the folder so that docker-compose uses that name.
      var composerPath = $path.join(conf, name)
      $fs.mkdir(composerPath)

      // Create docker-compse.yml.
      var yaml = $path.join(composerPath,'docker-compose.yml')
      $fs.writeFileSync(yaml, $yaml.safeDump(json))

      console.log('docker-compose: %s -> %s', name + extension, yaml)
  })
});
