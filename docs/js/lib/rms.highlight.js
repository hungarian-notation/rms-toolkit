import * as tokens from "./rms.highlight.tokens.js"

export { tokens };

const TOKEN_REGEXP = /(rnd\(|[,)]|[ \t\r\n]+)/g;

export function classify(token) {
  if (token.length > 2 && token.slice(0, 2) == "/*") {
    return [ "comment" ];
  }

  let classes = [];

  for (var i = 0; i < tokens.classes.length; ++i) {
    var c = tokens.classes[i];

    in_class: for (var j = 0; j < tokens[c].length; ++j) {
      if (token.replace(/\&lt\;/g, "<").replace(/\&gt\;/g, ">") === tokens[c][j]) {
        classes.push(c);
        break in_class;
      }
    }
  }

  if (classes.length == 0) {
    if (token.match(/[0-9]+/)) {
      classes.push("integer");
    } else if (token.match(/[ \t\r\n]+/)) {
      classes.push("whitespace");
    } else {
      classes.push("name");
    }
  }

  return classes;
}

export function tokenize(source) {
  let raw = source.split(TOKEN_REGEXP).filter(each => !(each === ""));

  let output = [];
  let inComment = false;
  let acc = "";

  for (var i = 0; i < raw.length; ++i) {
    let next = raw[i];

    if (inComment) {
      acc += next;

      if (next == "*/") {
        inComment = false;
        output.push(acc);
        acc = "";
      }
    } else {
      if (next === "/*") {
        inComment = true;
        acc = next;
      } else {
        output.push(next);
      }
    }
  }


  return output;
}
