m4_include([chars.m4])


#####

m4_define([_doc_lang],        [m4_define([__DOCLANG__], [$1])])
m4_define([_doc_lang_indir],  [m4_indir([$1][_]__DOCLANG__, m4_shift($@))])

#####

m4_define([doc_raw],        [m4_divert_text([], [$1])])

#####

m4_define([_doc_make_paragraphs_regexp_2], [[\([^$1].*\)]])
m4_define([_doc_make_paragraphs_regexp_1], [_doc_make_paragraphs_regexp_2(m4_join([], $@))])
m4_define([_doc_make_paragraphs_regexp], [_doc_make_paragraphs_regexp_1(m4_tab_char, [ ])])
m4_define([_doc_make_lines_regexp_2],  [[[$1]]])
m4_define([_doc_make_lines_regexp_1],  [_doc_make_lines_regexp_2(m4_join([], $@))])
m4_define([_doc_make_lines_regexp],    [_doc_make_lines_regexp_1(m4_newline_char, m4_carriage_return_char)])
m4_define([_doc_paragraph_fragment_normalize],     [m4_bregexp([$1], _doc_make_paragraphs_regexp(), [[[[\1 ]]]])])
m4_define([_doc_paragraph_fragment],               [m4_ifblank([$1], [[,]], [_doc_paragraph_fragment_normalize([$1])])])
m4_define([_doc_paragraphs_normalize_parts],       [m4_map_args([_doc_paragraph_fragment], $1)])
m4_define([_doc_paragraphs_split_fragments],       [m4_unquote(m4_split([$1], _doc_make_lines_regexp()))])
m4_define([_doc_paragraphs_process_fragments],     [m4_dquote(m4_do(m4_map_args_sep([_doc_paragraph_fragment(], [)], [,], _doc_paragraphs_split_fragments([$1]))))])
m4_define([_doc_paragraph_expansion],              [m4_dquote(m4_strip([$1]))])

# _doc_paragraphs_split_fragments(text)
# ------------------------------------
# Returns a list of paragraphs in the given text. A paragraph is a group of
# lines separated from other lines by an empty line.
m4_define([doc_split_paragraphs],
[m4_map_sep([_doc_paragraph_expansion], [[,]], _doc_paragraphs_process_fragments([$1]))])




m4_define([_doc_format_text], [_doc_lang_indir([$0], $@)])

m4_define([doc_text],
  [doc_raw(_doc_format_text([$1]))])

# doc_escape(STRING)
m4_define([doc_escape], [_doc_lang_indir([_$0], $@)])


m4_define([_doc_format_header], [_doc_lang_indir([$0], $@)])

m4_define([__reduce__],
  [m4_strip(m4_flatten([$1]))])

m4_define([doc_header],
  [doc_raw(_doc_format_header([$1], [$2]))])

m4_define([doc_title],
  [doc_header(1, [$1])])

m4_define([doc_chapter],
  [doc_header(1, [$1])])

m4_define([doc_category],
  [doc_header(2, doc_pre(doc_escape([<]$1[>])) _doc_anchor(m4_default([$2], [$1])))])

m4_define([_doc_anchor], [<a id="$1"></a>])

m4_define([_echo], [m4_errprintn([$1])][$1])

# _doc_format_syntax("command"|"attribute", name[, args], [ ...statements ])
# ------------------------------------------------------------------
m4_define([_doc_format_syntax], [_doc_lang_indir([$0], $@)])

m4_define([doc_command],
  [doc_raw(_doc_format_syntax(command, $@))])

m4_define([doc_attribute],
  [doc_raw(_doc_format_syntax(attribute, $@))])


m4_define([doc_repeat], [m4_for([__i__], [1], [$2], [1], [$1])])

m4_define([doc_nbsp], [doc_repeat([&nbsp;], [$1])])

m4_define([_doc_opt_argument_info],
  [][m4_ifnblank([$1], [m4_newline_char()][[]][])])

m4_define([_doc_format_definition], [_doc_lang_indir([$0], $@)])
m4_define([_doc_format_quote], [_doc_lang_indir([$0], $@)])

m4_define([doc_definition],
  [doc_raw(_doc_format_definition([$1]))])
m4_define([doc_quote],
  [doc_raw(_doc_format_quote([$1]))])

m4_define([doc_argument],   [doc_raw(_doc_lang_indir([_doc_format_argument], $@))])
m4_define([doc_hr],         [_doc_lang_indir([_$0], $@)])
m4_define([doc_link],       [_doc_lang_indir([_$0], $@)])
m4_define([doc_pre],        [_doc_lang_indir([_$0], $@)])
m4_define([doc_ref],        [doc_link(m4_if([$#], [1], [doc_pre($1)], [$1]), m4_default([$2], [[#]][$1]))])

m4_define([doc_strong],       [_doc_lang_indir([_$0], $@)])
