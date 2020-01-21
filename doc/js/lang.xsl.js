import { CodeBlockElement } from "./elements/code-block.js";
import { DocRefElement, ArgRefElement } from "./elements/doc-ref.js";
import { installScrollToElement } from "./lib/scroll-to-element.js"

$(() => {
  installScrollToElement();
  customElements.define('code-block', CodeBlockElement);
  customElements.define('doc-ref',  DocRefElement);
  customElements.define('arg-ref',  ArgRefElement);
})

function sanitizeToken(mode, token) {
  if (mode == "target") {
    return token.replace(/[<>]/g, "");
  } else {
    return token.replace(/[<>]/g, (x) => {
      return x == "<" ? "&lt;" : "&gt;";
    });
  }
}

$(() => {

  $("section").each(function (i, e) {
    e.setAttribute("data-local-id", e.getAttribute("name"));
  });

  $("li[class~='token']").each(function (i, e) {
    let token = e.innerText;
    e.innerHTML = `<doc-ref target="${sanitizeToken("target", token)}" data-display-name="${sanitizeToken("display", token)}"/>`;
  });

});
