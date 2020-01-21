m4_include([doc.m4])
_doc_lang([md])

# m4_define\(\[_?(doc_[a-z0-9_]+([^d]|[^m][d]|[^_][m][d]))\]
# m4_define\(\[_?(doc_[a-z0-9_]+([^d]|[^m][d]|[^_][m][d]))\]
# m4_define([_$1_md]

m4_define([_doc_line_sep_2], [[$1][$2]])

m4_define([_doc_line_sep], [_doc_line_sep_2([]m4_newline_char()m4_if([$#], [2], [$2], []), [$1])])

m4_define([_doc_join_text],
[m4_if([$#], [4],
[[$3]m4_join(_doc_line_sep([$2], [$4]), $1)],
[[$3]m4_join(_doc_line_sep([$2]), $1)])])

m4_define([_doc_join_paragraphs],
  [m4_if([$#], [4],
    [_doc_join_text(doc_split_paragraphs([$1]), [$2], [$3], [$4])],
    [_doc_join_text(doc_split_paragraphs([$1]), [$2], [$3])])])

m4_define([_doc_format_text_md], [_doc_join_paragraphs([$1], [], [], [m4_newline_char()])])

m4_define([_doc_format_header_md],
  [m4_for([__i__], [1], [$1], [1], [[#]]) $2])

m4_define([_doc_wrap_params], [[**(**$1**)**]])

m4_define([_doc_params], [m4_ifnblank([$1], [m4_newline_char(): ___(default: `$1`)___])])

m4_define([_doc_format_argument_md], [`$1` : [$2] m4_newline_char()_doc_format_definition([$4])_doc_params([$3])[]m4_newline_char()])

m4_define([_doc_strong_md],   [**[$1]**])
m4_define([_doc_hr_md],       [m4_newline_char()[---]])
m4_define([_doc_link_md],     [@<:@$1@:>@@{:@$2@:}@])
m4_define([_doc_pre_md],      [`$1`])

m4_define([_doc_escape_md], [m4_bpatsubst([$1], [_], [\\_])])

m4_define([_doc_format_definition_md], [_doc_format_text([$1],
  [: ],
  [: ],
  [: &nbsp;m4_newline_char()])])

m4_define([_doc_format_quote_md], [_doc_format_text([$1],
  [> ],
  [> ],
  [])])

m4_define([_doc_format_syntax_md],
  [_doc_format_header(3, **[doc_escape($2)]** m4_ifnblank(
    [$3], [m4_map_args_w([$3], [doc_pre(], [)], [ ])]) _doc_anchor([$2]))])
