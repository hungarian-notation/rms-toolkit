import * as rms from '../lib/rms.highlight.js';

function isEmptyString(str) {
  return !!str.match(/^[ \t]*$/);
}

function getPrefixLength(str) {
  if (isEmptyString(str)) {
    return -1;
  } else {
    let match = str.match(/^[ \t]+/);

    if (match) {
      return match[0].length;
    } else {
      return 0;
    }
  }
}

function getCommonPrefixLength(strings) {
  if (strings.length <= 1) {
    return "";
  } else

  var prefixLen = -1;

  for (var i = 1; i < strings.length; ++i) {
    let here = getPrefixLength(strings[i]);

    if (here >= 0) {
      if (prefixLen == -1 || here < prefixLen) {
        prefixLen = here;
      }
    } else {
      // ignore empty lines
    }
  }

  return prefixLen;
}

function unindentLines(lines) {
  let prefix = getCommonPrefixLength(lines);
  let replacementLines = lines.map(each => (each.slice(prefix)));

  while (replacementLines.length > 0 && isEmptyString(replacementLines[0])) {
    replacementLines = replacementLines.slice(1);
  }

  while (replacementLines.length > 0 && isEmptyString(replacementLines[replacementLines.length - 1])) {
    replacementLines = replacementLines.slice(0, replacementLines.length - 1);
  }

  return replacementLines;
}

async function defer(payload) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      try {
        var result = payload();
        resolve(result);
      } catch (e) {
        reject(e);
      }
    });
  });
}

async function highlight(source, lang) {
  source = await defer(() => unindentLines(source.split(/[\r]?[\n]/g)).join("\n"));
  let tokens = lang.tokenize(source);

  let processed = tokens.map(token => {
    let classes = lang.classify(token);

    if (classes.length > 0) {
      if (token.match(/[\n]/)) {
        let parts = token.split(/(\n)/g);

        return {
          source: parts.map(each => `<span class="syntax ${classes.map(c => `syntax--${c}`).join(" ")}">${each}</span>`),
          fragments: parts
        }
      } else {
        return {
          source: [ `<span class="syntax ${classes.map(c => `syntax--${c}`).join(" ")}">${token}</span>` ],
          fragments: [ token ]
        }
      }

    } else {
      return {
        source: [ token ],
        fragments: [ token ]
      };
    }
  });

  let acc   = [];
  let divs  = [];

  function chunk() {
    let chunkSource = acc.join("");
    acc = [];
    let chunkDiv = document.createElement("div");
    chunkDiv.setAttribute("class", "code-block-content")
    chunkDiv.innerHTML = chunkSource;
    divs.push(chunkDiv);
  }

  for (var i = 0; i < processed.length; ++i) {
    let part = processed[i];

    for (var j = 0; j < part.source.length; ++j) {
      let source = part.source[j];
      let fragment = part.fragments[j];

      if (acc.length >= 100 && fragment == "\n") {
        /* CHUNK HERE */
        /* Throw away newline */
        chunk();
      } else {
        acc.push(source);
      }
    }
  }

  if (acc.length > 0) {
    chunk();
  }

  return divs;
}


/*
function unindentCodeBlocks() {
  $("code-block").each((index, element) => {
    checkPreElement(element);
    let lines = $(element).text().split(/[\r]?[\n]/g);
    let replacementLines = unindentLines(lines);
    $(element).html(replacementLines.join("\n"))
  });
}
*/


export class CodeBlockElement extends HTMLElement {
  constructor() {
    const self = super();

    var shadow = this.attachShadow({ mode: 'open' });
    var style = document.createElement('style');

    style.textContent = `
      div.code-block-content--outer {
        font-family: inherit;
        background: inherit;
        padding: 10px;

        border-left: 5px solid #ddd;
      }

      div.code-block-content {
        font-family: inherit;
        background: inherit;

        display: block;
        padding: 0px;
        white-space: pre;
        font-family: monospace;
      }

      .syntax {
        white-space: pre;
      }

      .syntax.syntax--comment {
        font-style: italic;
        color: #888;
      }

      .syntax.syntax--keyword {
        font-weight: bold;
      }

      .syntax.syntax--setting {
        font-weight: bold;
        color: #660;
        font-style: italic;
      }

      .syntax.syntax--keyword.syntax--command {
        font-weight: bold;
        color: #00a;
      }

      .syntax.syntax--keyword.syntax--attribute {
        font-weight: bold;
        color: #080;
      }

      .syntax.syntax--keyword.syntax--macro {
        font-weight: bold;
        color: #a00;
      }

      .syntax.syntax--integer {
        color: #660;
      }

      .syntax.syntax--name {
        color: #606;
        font-style: italic;
      }
    `;

    shadow.appendChild(style);

    window.setTimeout(async () => {
      shadow.appendChild(await this.getShadowWrapperElement());
    });
  }

  async getShadowWrapperElement() {
    let chunks = highlight(this.innerHTML, rms);
    this.innerText        = "";

    let wrapperElement    = document.createElement('div');
    wrapperElement.setAttribute("class", "code-block-content--outer");
    let resolved = await chunks;
    resolved.forEach(chunk => wrapperElement.appendChild(chunk))
    return wrapperElement;
  }

  format() {
    if (this._isFormatted) {
      return;
    } else {
      this._isFormatted = true;
    }
  }

  connectedCallback() {
    if (this.isConnected) {
      this.format();
    }
  }
}
