module.exports = (grunt) ->
  
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    date: grunt.template.today 'dd-mm-yyyy'
    clean:
      dist: ['dist'],
      test: ['test/**/*.js']
    coffee:
      app:
        files: [{
          expand: true,
          cwd: 'src/'
          src: ['*.coffee'],
          dest: 'dist/',
          ext: '.js'
        }]
      test:
        files: [{
          expand: true,
          cwd: 'test/',
          src: ['**/*.coffee'],
          dest: 'test/',
          ext: '.js'
        }]
    uglify:
      options:
        banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - <%= date %> */\n'
        report: 'gzip'
      dist:
        files:
          'dist/<%= pkg.name %>.min.js': 'dist/<%= pkg.name %>.js'
    mochaTest:
      options:
        reporter: 'spec'
      test:
        src: ['test/all/**/*.js', 'test/node/**/*.js']
    mocha:
      options:
        reporter: 'Spec'
        run: true
      all: ['test/browser/*.html']
    coffeelint:
      app: ['src/*.coffee']
      tests: ['test/**/*.coffee']
      grunt: ['gruntfile.coffee']
    template:
      signature:
        src: 'test/templates/browsertest.html'
        dest: 'test/browser/signature.html'
        engine: 'handlebars'
        variables:
          title: 'Signature'
          script: '../all/signature.js'
      environment:
        src: 'test/templates/browsertest.html'
        dest: 'test/browser/environment.html'
        engine: 'handlebars'
        variables:
          title: 'Environment'
          script: '../all/environment.js'
      injection:
        src: 'test/templates/browsertest.html'
        dest: 'test/browser/injection.html'
        engine: 'handlebars'
        variables:
          title: 'Injection'
          script: '../all/injection.js'
      module:
        src: 'test/templates/browsertest.html'
        dest: 'test/browser/module.html'
        engine: 'handlebars'
        variables:
          title: 'Module'
          script: '../all/module.js'
        

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)
  
  grunt.registerTask 'test', [
    'coffee:test'
    'template'
    'coffeelint'
    'mochaTest'
    'mocha'
  ]
  
  grunt.registerTask 'default', 'Default task', ['coffee:app', 'uglify', 'test']