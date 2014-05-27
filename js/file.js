// Generated by CoffeeScript 1.7.1
(function() {
  var File, Wrapper, files, fs, path, stream, touch,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  stream = require('stream');

  path = require('path');

  touch = require('touch');

  fs = require('fs.extra');

  files = {};

  File = (function(_super) {
    __extends(File, _super);

    File.throttle = 200;

    function File(filepath, msg, cb) {
      this.filepath = filepath;
      this.msg = msg;
      File.__super__.constructor.apply(this, arguments);
      this.bootstrap((function(_this) {
        return function(err) {
          return _this.watch(function() {
            return typeof cb === "function" ? cb() : void 0;
          });
        };
      })(this));
    }

    File.prototype._read = function(size) {};

    File.prototype.watch = function(cb) {
      fs.watch(this.filepath, {
        persistent: false
      }, (function(_this) {
        return function(event) {
          if ((event != null) && (_this.stopped == null)) {
            return _this.push(_this.msg);
          }
        };
      })(this));
      return setTimeout(cb, File.throttle);
    };

    File.prototype.bootstrap = function(cb) {
      var dir, _;
      dir = path.dirname(this.filepath);
      _ = (function(_this) {
        return function() {
          return touch(_this.filepath, function(err) {
            if (err) {
              return typeof cb === "function" ? cb(err) : void 0;
            }
            return typeof cb === "function" ? cb() : void 0;
          });
        };
      })(this);
      return fs.exists(dir, function(exists) {
        if (!exists) {
          return fs.mkdirp(dir, function(err) {
            return _();
          });
        } else {
          return _();
        }
      });
    };

    File.prototype.close = function() {
      this.stopped = true;
      fs.unwatchFile(this.filepath);
      return this.push(null);
    };

    return File;

  })(stream.Readable);

  Wrapper = (function(_super) {
    __extends(Wrapper, _super);

    function Wrapper(filepath, msg, cb) {
      var file, finish;
      this.filepath = filepath;
      this.msg = msg;
      Wrapper.__super__.constructor.apply(this, arguments);
      this.normalize();
      finish = (function(_this) {
        return function() {
          files[_this.filepath].pipe(_this);
          return typeof cb === "function" ? cb() : void 0;
        };
      })(this);
      file = files[this.filepath];
      if (files[this.filepath] == null) {
        files[this.filepath] = new File(this.filepath, this.msg, (function(_this) {
          return function(err) {
            file = files[_this.filepath];
            return finish();
          };
        })(this));
      } else {
        finish();
      }
    }

    Wrapper.prototype.normalize = function() {
      this.filepath = path.resolve(this.filepath);
      if (this.msg == null) {
        return this.msg = this.filepath;
      }
    };

    Wrapper.prototype.close = function() {
      if (files[this.filepath] != null) {
        files[this.filepath].close();
        return delete files[this.filepath];
      }
    };

    Wrapper.close = function() {
      var file, filepath, _results;
      _results = [];
      for (filepath in files) {
        file = files[filepath];
        _results.push(file.close());
      }
      return _results;
    };

    return Wrapper;

  })(stream.PassThrough);

  module.exports = Wrapper;

}).call(this);