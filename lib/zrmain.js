/* Licensed under the MIT license. */

var documentReady = false;
$(function() { documentReady = true; });
function execDeferred(callback) {
  if (documentReady) callback();
  else $(callback);
}

function zrSetCounter(value, name) {
  value = String(value);
  value = ("00000" + value).substring(value.length)
  execDeferred(function() {
    $("#counter-mini").add("#counter-index").text(value);
  });
}

$(function() {

  var clog = $("#changelog");
  if (clog.height() < 100) { clog.css("overflowY", "visible"); }

  $._id = 0;
  $.fn.extend({ findId: function() {
    var id = this.attr("id");
    if (!id) { this.attr("id", id = "_elt" + (++$._id)); }
    return id;
  }});
  if (location.hash == "")
  tableOfContents("table-contents", makeOutline());
  function makeOutline() {
    return $("#canvas").find("div.section").map(section);
    function section() {
      return { title: $(this).find("h2").eq(0).html(), id: $(this).findId(),
               sub: $(this).find("div.subsection").map(subsection) };
    }
    function subsection() {
      return { title: $(this).find("h3").eq(0).html(), id: $(this).findId(),
               sub: $(this).find("h4").map(subsubsection) };
    }
    function subsubsection() {
      return { title: $(this).html(), id: $(this).findId(), sub: [] };
    }
  }
  function tableOfContents(id, outline) {
    var elt = $("#" + id);
    if (elt.size() == 1) {
      elt.append("<span class='lbl'>目次</span>").append(ul(outline));
    }
    function ul(list) {
      if (!list || list.length == 0) { return null; }
      var elt = $("<ul></ul>");
      $.each(list, function(i, ent) {
        var ht = "<a href='#" + ent.id + "'>" + ent.title + "</a>";
        elt.append($("<li></li>").html(ht).append(ul(ent.sub)));
      });
      return elt;
    }
  }
});
