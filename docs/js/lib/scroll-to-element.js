export function scrollToElement(e) {
  if (!e) {
    return;
  } else {
    console.dir(e);
  }

  let prescroll   = 100;
  let target      = e;
  let currentTop  = $("main").scrollTop();
  let targetTop   = currentTop + $(target).offset().top - prescroll;

  history.replaceState({}, '', "#" + e.getAttribute("id"));
  history.pushState({}, '', "#" + e.getAttribute("id"));
  history.back();

  console.log(`at: ${currentTop}, want to be at: ${targetTop}`);

  if (target) {
    $("main").animate({
      scrollTop: targetTop
    }, 100);
  }
}

export function installScrollToElement(selector) {
  $(() => {
    // redefine the behavior of the navigation links to use scrollToElement

    $(selector || "a[href^='#']").click(function (e) {
      console.log(this);

      let targetId = this.getAttribute("href").slice(1);
      let targetElement = $(`[id='${targetId}']`)[0];

      e.preventDefault();
      scrollToElement(targetElement);
    });

  });
}
