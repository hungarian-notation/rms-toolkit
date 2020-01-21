#! /usr/bin/env bash

cd "$(dirname "$0")"
autom4te -l m4sugar -I "." "md.doc.m4" "rms.doc.m4" > "../documentation.md"
autom4te -l m4sugar -I "." "html.doc.m4" "rms.doc.m4" > "../documentation.htm"
