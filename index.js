const $fs = require('fs')
const $path = require('path')
const $yaml = require('js-yaml')
const conf = '/etc/infrastructure'
const data = '/usr/share'

/**
 * Filter callback when enumerating files, ignores directories.
 * @callback: fileFilter
 * @param {string} name - name of the file without extension.
 * @param {string} extension - extension of the file, starts with a dot.
 * @param {string} path - complete path to the file.
 * @returns hash either an object to add or falsy to ignore.
 */

/**
 * Enumerates file entries from the give path.
 * @param {string} path - path to start looking.
 * @param {array} results - (optional) array of returned results.
 * @param {array} matches - (optional) array of file extensions to match.
 * @param {fileFilter} filter - (optional) function to filter results.
 */
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

/**
 * Transforms a JSON object that represents a docker-compose file and
 * performs replacements.
 * @param {string} composerName - name of the composer file sans extension.
 * @param {hash} json - docker-composer json representation.
 */
function transform(composerName, json) {
  const ignored = ['services', 'version', 'volumes']

  /**
   * Transforms an environment hash into an array.
   * @param {hash} image - image object.
   */
  function environments(image) {
    var environment = []
    if (image.environment) {
      var keys = Object.keys(image.environment)
      for (var index = 0; index < keys.length; index++) {
        var key = keys[index]
        var value = image.environment[key];
        environment.push([key, value].join('='))
      }
      image.environment = environment;
    }
  }

  /**
   * Transforms volumes marked with a question mark (?) and expands
   * the path based on the image name.
   * @param {string} imageName - name of the image.
   */
  function volumes(imageName, image) {
    const clean = imageName.replace(' ', '-')
    const path = $path.join(data, composerName, clean)
    if (image.volumes) {
      var keys = Object.keys(image.volumes)
      for (var index = 0; index < image.volumes.length; index++) {
        var volume = image.volumes[index]
        if (volume[0] === '?') {
          image.volumes[index] = volume.replace('?', path)
        }
      }
    }
  }

  // Get the top-level keys and enumerate them for image definitions.
  var images = Object.keys(json)
  for (var index = 0; index < images.length; index++) {
    var name = images[index]
    var clean = name.toLowerCase()
    if (ignored.indexOf(clean) >= 0) {
      // Skip anything that is ignored. Not supporting docker-compose 2.0
      // at this time.
      continue;
    }
    var image = json[name]
    environments(image)
    volumes(name, image)
  }
}

/**
 * Entry point to start generating files.
 */
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

      transform(name, json)

      // Create the folder so that docker-compose uses that name.
      var composerPath = $path.join(conf, name)
      if (!$fs.lstatSync(composerPath).isDirectory()) {
        $fs.mkdir(composerPath)
      }

      // Create docker-compse.yml.
      var yamlPath = $path.join(composerPath,'docker-compose.yml')
      var yaml = $yaml.safeDump(json)
      $fs.writeFileSync(yamlPath, yaml)

      // Some debugging love.
      console.log('docker-compose: %s -> %s', name + extension, yamlPath)
      if (process.env.debug) {
        console.log(yaml)
      }
  })
});
