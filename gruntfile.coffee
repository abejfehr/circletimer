# gruntfile.coffee
# @author Abe Fehr
#
module.exports = (grunt) ->

  # Necessary "includes"
  grunt.loadNpmTasks "grunt-coffeelint"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-sass"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-postcss"

  # Task declarations
  grunt.initConfig

    coffee:
      dist:
        options:
          bare: true
          join: true
          sourceMap: false
        files: {
          "dist/circletimer.js": ["src/circletimer.coffee"]
        }

    coffeelint:
      gruntfile:
        files:
          src: ["gruntfile.coffee"]
      src:
        files:
          src: ["src/*.coffee"]

    sass:
      dist:
        options:
          style: "compressed"
          sourcemap: "none"
        files: [
          expand: true
          cwd: "src"
          src: ["*.scss"]
          dest: "dist"
          ext: ".css"
        ]

    uglify:
      dist:
        files:
          "dist/circletimer.min.js": ["dist/circletimer.js"]

    postcss:
      options:
        processors: [
          require('autoprefixer-core')({browsers: 'last 2 versions'})
        ]
      dist:
        src: "dist/*.css"

  # Task registration
  grunt.registerTask "lint", ["coffeelint"]
  grunt.registerTask "build", [
    "sass"
    "coffee:dist"
    "uglify"
    "postcss"
  ]
  grunt.registerTask "default", ->
    grunt.task.run ["lint", "build"]