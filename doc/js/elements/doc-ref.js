
import { scrollToElement } from "../lib/scroll-to-element.js"

const DocRefRegExp = /^(?:([^:]*)(?:[/]|::))?([^:]*)$/

export class DocRefElement extends HTMLElement  {
  constructor() {
    super();

    let self          = this;
    let shadow        = this.attachShadow({ mode: 'open' });

    let innerStyle    = document.createElement("style");
    let innerSpan     = document.createElement("span");

    innerStyle.innerText = `
      span {
        all:              inherit;
        cursor:           pointer;
        user-select:      none;
        font-size:        90%;
      }

      span[data-invalid] {
        all:              inherit;
        cursor:           default;
        user-select:      none;
        font-size:        90%;
      }
    `;

    innerSpan.innerHTML = `${this.getDisplayName()}`;

    shadow.appendChild(innerStyle);
    shadow.appendChild(innerSpan);


    this.onclick = (e) => self.clickCallback(e);

    this._innerStyle = innerStyle;
    this._innerSpan = innerSpan;
  }

  getLocalSectionElement() {
    return $(this).parents("section")[0];
  }

  getDisplayName() {
    return (this.getAttribute("data-display-name") || this.getAttribute("name") || this.getTargetString()).replace(/[<>]/g, (x) => {
      return x == "<" ? "&lt;" : "&gt;";
    });
  }

  getTargetString() {
    return this.getAttribute("target");
  }

  getTargetDetails() {
    let matched = DocRefRegExp.exec(this.getTargetString());

    if (matched) {
      let section = matched[1];
      let topic = matched[2];
      return { section, topic };
    } else {
      return undefined;
    }
  }

  resolveSection(name) {
    let direct = $(`section[id="${name}"]`)[0];

    if (direct) {
      return direct;
    } else {
      let indirect = $(`section[name="${name}"]`)[0]
        || $(`section[name*="${name}"]`)[0];

      if (indirect) {
        return indirect;
      } else {
        return undefined;
      }
    }
  }

  getTargetElement() {
    let details   = this.getTargetDetails() || { section: undefined, topic: "" };
    let scope     = $(document);

    if (details.section) {
      let found = this.resolveSection(details.section);

      if (!found) {
        // console.log("failed to narrow scope");
      } else {
        scope = $(found);
      }
    }

    let matched   = scope.find(`[data-local-id="${details.topic}"]`).toArray();

    if (matched.length > 1) {
      let close = matched.filter(each => {
        let sectionElement = $(each).parent("section")[0];
        if (sectionElement == this.getLocalSectionElement()) {
          return true;
        } else {
          return false;
        }
      });

      if (close[0]) {
        return close[0];
      } else {
        return matched[0];
      }
    } else {
      return matched[0];
    }
  }

  getTargetElementId() {
    let target = this.getTargetElement();

    if (target) {
      return target.getAttribute("id");
    } else {
      return this.getTargetString();
    }
  }

  clickCallback(e) {
    scrollToElement(this.getTargetElement());
  }

  _check() {
    var valid = !!this.getTargetElement();

    if (valid) {
      this._innerSpan.removeAttribute("data-invalid")
      this.removeAttribute("data-invalid")
    } else {
      this._innerSpan.setAttribute("data-invalid", true);
      this.setAttribute("data-invalid", true);
    }
  }

  connectedCallback() {
    var self = this;

    $(() => {
      self._check();
    });
  }
}

export class ArgRefElement extends HTMLElement {
  constructor() {
    super();
  }

  update() {
    let index = (this.getAttribute("index") || "").trim();
    let name  = (this.getAttribute("name") || "").trim();

    if (index) {
      index           = Number(index);
      let indexString = index.toFixed(0);
      try {
        let context   = $(this).parents(".topic");
        let found = context.find(`[data-argument-index="${indexString}"]`);
        if (found[0]) {
          name = found[0].getAttribute("data-argument-name");
        }
      } catch (e) {
        name = index.toFixed(0);
      }
    }

    this.innerText = name;
  }

  connectedCallback() {
    let self = this;
    setTimeout(() => self.update());
  }
}
