module.exports = (grunt) ->
  
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      compile:
        files: [{
          expand: true,
          cwd: 'src/'
          src: ['*.coffee'],
          dest: 'dist/',
          ext: '.js'
        }]
    uglify:
      options:
        banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today("dd-mm-yyyy") %> */\n'
        report: 'gzip'
      dist:
        files:
          'dist/<%= pkg.name %>.min.js': 'dist/<%= pkg.name %>.js'
    mochaTest:
      options:
        reporter: 'spec'
      test:
        src: ['test/**/*.js']
    coffeelint:
      app: ['src/*.coffee'],
      tests: ['test/*.coffee'],
      grunt: ['gruntfile.coffee']

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)
  
  grunt.registerTask 'test', ['coffeelint', 'mochaTest']
  grunt.registerTask 'default', 'Default task', ['coffee', 'uglify', 'test']