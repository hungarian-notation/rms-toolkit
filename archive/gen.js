var fs = require('fs');

const INPUT_PATH    = process.argv[2];
const OUTPUT_PATH   = process.argv[3];

const DIRECTIVE_PATTERN = /^(?:[ \t]*)[#](?<directive>.*)$/;

var input = fs.readFileSync(INPUT_PATH, 'utf8');

class ContextState {
  constructor(parent) {
    this._parent = parent;
  }

  parent() {
    return this._parent;
  }

  directive(id, argv) { }
  content(text) { }
}

class Context {
  constructor() {
    this._root = this._state = new DocumentNodeContext(null, "root");
  }

  directive(id, argv) {
    this._state = this._state.directive(id, argv) || this._state;
  }

  content(text) {
    this._state.content(text);
  }

  asXML() {
    return this._root.asXML();
  }
}

const DOCUMENT_NODE_TIERS = [
  "root",
  "chapter",
  "category",
  "syntax",
  "argument",
  "details"
]

const ATTRIBUTE_NODES = {
  "argument_type":    (argv) => ( { key: "type", value: argv.join(" ") } ),
  "argument_default": (argv) => argv.length > 0 ? ( { key: "default", value: argv.join(" ") } ) : undefined
}

function isDocumentNode(id) {
  return DOCUMENT_NODE_TIERS.indexOf(id) !== -1;
}

function getDocumentNodeTier(id) {
  return DOCUMENT_NODE_TIERS.indexOf(id);
}

function createDocumentNode(host, id, argv) {
  switch (id) {
    default:
      return new DocumentNodeContext(host, id, argv);
  }
}

class DocumentNodeContext extends ContextState {

  constructor(parent, type, argv) {
    super(parent);

    this._type      = type;
    this._tier      = DOCUMENT_NODE_TIERS.indexOf(this._type);
    this._children  = [];
    this._argv      = argv;
    this._attrs     = [];

    this.begin(argv)
  }

  depth() {
    return this._parent ? (this._parent.depth() + 1) : 0;
  }

  begin(argv) {
    let indent = ("  ").repeat(this.depth());
    let attrs = [];

    switch (this._type) {
      case "category":
        attrs = [ { key: "id", value: argv.join(" ") } ]
        break;
      case "syntax":
        attrs = [ { key: "name", value: argv[1] }, { key: "type", value: argv[0] } ]
        break;
      case "argument":
        attrs = [ { key: "name", value: argv.join(" ") } ]
        break;
      default:
        /* nop */
    }

    this._attrs = attrs;
  }

  end() {

  }

  asXML() {
    let indent = this.indent();
    let indent_inner = this.indent(1);

    let open = `${indent}<${this._type}${
      this._attrs.length > 0
        ? " " + this._attrs.map(each => `${each.key}="${each.value}"`).join(" ")
        : ""}>`;
    let close = `${indent}</${this._type}>`;

    let parts = [ open ];

    this._children.forEach(child => {
      parts.push(child.asXML())
    });

    parts.push(close);

    return parts.join("\n");
  }

  indent(extra) {
    return ("  ").repeat(this.depth() + (extra || 0));
  }

  directive(id, argv) {
    if (this._end) {
      throw new Error("already closed this node");
    }

    let result = undefined;

    if (id == `end_${this._type}`) {
      this.end();
      result = this._parent;
    } else if (isDocumentNode(id)) {
      if (getDocumentNodeTier(id) > this._tier) {
        // child node
        let child = createDocumentNode(this, id, argv);
        this._children.push(child);
        result = child;
      } else {
        // handle in parent
        this.end();
        result = this._parent.directive(id, argv);
      }
    } else {
      if (ATTRIBUTE_NODES[id]) {
        let attr = ATTRIBUTE_NODES[id](argv);
        if (attr) {
          this._attrs.push(attr);
        }
      }
    }

    return result;
  }

  content(text) {
    this._children.push(new CharacterData(this, text.trim()))
  }

}

class CharacterData extends DocumentNodeContext {
  constructor(parent, text) {
    super(parent, "CDATA", [ text ]);
    this._text = text;
  }

  escaped() {
    return this._text
      .replace("&", "&amp;")
      .replace("<", "&lt;")
      .replace(">", "&gt;")
      .replace("'", "&apos;")
      .replace("\"", "&quot;");
  }

  asXML() {
    return `${this.indent()}${this.escaped()}`;
  }
}

function parse(input) {
  let lines = input.split(/[\r]?[\n]/g).map(each => each.trim()).filter(each => each !== "")
  let directives = lines.map(each => {
    let match = DIRECTIVE_PATTERN.exec(each);
    if (match) {
      let parts = match.groups.directive.split(/\s+/g);
      let id    = parts[0];
      let args  = parts.slice(1);
      return ({
        type: 'directive',
        directive: id,
        arguments: args
      })
    } else {
      return ({
        type: 'content',
        content: each
      })
    }
  });

  let ctx = new Context();

  directives.forEach(each => {
    if (each.type == 'directive') {
      ctx.directive(each.directive, each.arguments);
    } else {
      ctx.content(each.content);
    }
  });

  console.log(ctx.asXML())
}

parse(input);
