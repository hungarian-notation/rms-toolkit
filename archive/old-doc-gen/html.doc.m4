m4_include([doc.m4])
_doc_lang([html])

doc_raw([
  <link href="https://fonts.googleapis.com/css?family=Roboto+Mono:400,700|Roboto:400,400i,700,700i&display=swap" rel="stylesheet">

  <style>

    .syntax .argument {
      color: #777;
    }

    span.syntax.command {
      color: #13a;
    }

    span.syntax.attribute {
      color: #183;
    }

    body {
      font-family: sans-serif;
    }

    code {
      font-family: 'Roboto Mono', 'Consolas', monospace;
    }

    div.argument {
      color: #222;
    }

    div.argument .name {
      font-weight: bold;
    }

    div.argument .type {
      font-style: italic;
    }

    div.definition {
      margin-left: 2em;
    }
  </style>
])

m4_define([_doc_format_header], [<h$1>[$2]</h$1>])
m4_define([_doc_hr_html], [<hr/>])
m4_define([_doc_pre_html], [<code>$1</code>])
m4_define([_doc_strong_html], [<strong>$1</strong>])

m4_define([_doc_html_arg], [<span class='argument'>[$1]</span>])

m4_define([_doc_format_syntax_html], [
  _doc_anchor([$2])
  <h3 class='syntax $1'>[[]<span class='id syntax $1'>$2</span>][[]m4_ifnblank([$3], [ m4_map_args_w([$3], [_doc_html_arg(], [)], [ ])])]</h3>
])

m4_define([_doc_paragraph], [<m4_default($2, [p])[]m4_ifblank([$3], [], [ $3])>$1</m4_default($2, [p])>])

# m4_define([_doc_paragraphs], [m4_errprintn([$1])][m4_foreach([__p__], doc_split_paragraphs([$1]), [<]m4_default([$2], [p])[>__p__</]m4_default(m4_default([$3], [$2]), [p])[>])])
m4_define([_doc_paragraphs], [m4_map_args_sep([_doc_paragraph(], [, m4_shift($@))], [], m4_dquote_elt(m4_unquote(doc_split_paragraphs([$1]))))])

m4_define([_doc_format_argument_html], [
  <div class='argument'>
    <div class='info-line'><span class='name'>$1</span> <span class='type'>$2</span></div>
    _doc_paragraphs([$4])
  </div>
])

m4_define([_doc_format_text_html], [<span class='text'>_doc_paragraphs([$1])</span>])
m4_define([_doc_format_quote_html], [<blockquote>_doc_paragraphs([$1])</blockquote>])
m4_define([_doc_format_definition_html], [<div class='definition'>_doc_paragraphs([$1])</div>])

m4_define([_doc_link_html], [<a href='$2'>$1</a>])
m4_define([_doc_escape_html_1], [_doc_escape_html_2(m4_bpatsubst([$1], [[<]], [&lt;]))])
m4_define([_doc_escape_html_2], [m4_bpatsubst([$1], [[>]], [&gt;])])
m4_define([_doc_escape_html], [_doc_escape_html_1($1)])
