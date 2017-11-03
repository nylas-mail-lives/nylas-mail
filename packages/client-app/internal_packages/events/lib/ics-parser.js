'use strict';

function convert(fileData, callback) {

  if (typeof fileData !== "string") {
    return callback(
      new Error("Invalid file data passed.")
    );
  }

  var lines = joinLines(fileData);
  var calendar = parseNode(lines, {});

  if (callback instanceof Function) {
    return callback(null, calendar);
  }

  return calendar;
}

function joinLines(fileData) {
  var lines = fileData.split(/\r\n|\n|\r/);
  var result = [];
  var buffer;

  while (lines.length > 0) {

    var line = lines.shift();

    var isNew = line[0] !== ' ';
    if (isNew) {
      if (buffer) {
        result.push(buffer);
      }
      buffer = line;
    } else {
      buffer = buffer + line.substr(1);
    }
  }

  if (buffer) {
    result.push(buffer);
  }

  return result;
}

function parseNode (lines, node) {

  var key;
  var val;

  while (lines.length > 0) {

    var line = lines.shift();
    var tag = /^([^:;]+)([:;])/.exec(line);

    if (!tag) {
      // Google calendar returns broken lines :'(
      lines[0] += line;
      continue;
    }

    switch (tag[1]) {
    case 'BEGIN':
      key = line.substr(tag[0].length);
      val = parseNode(lines, {});

      if (node[key]) {
        val = [].concat(node[key], val);
      }

      node[key] = val;
      break;

    case 'END':
      return node;

    default:
      key = tag[1];
      val = parseValue(
        line.substr(tag[0].length)
      );

      if (node[key]) {
        node[key] = [].concat(node[key] || [], val);
      } else {
        node[key] = val;
      }
    }
  }

  return node;
}

function parseValue (value) {
  var result = {};
  var pairs = value.split(':');
  while (pairs.length > 0) {
    var p = pairs.shift().split('=', 2);
    if (p.length === 1 && pairs.length === 0) {
      return p[0];
    } 
    var pKey = p[0].split( ';')[0];

    if (result[pKey]) {
      result[pKey] = [].concat(result[pKey], p[1]);
    } else {
      result[pKey] = p[1];
    }
  }
  return result;
}

module.exports = {
  convert: convert
}
