---
title: Regular Expressions
---

# Regular Expressions

`type(regex)` is a compiled regular expression. Compile it once, then search, match, iterate, split and replace with
it. The engine is a Pike VM, a simulation of the Thompson automaton that carries the groups. Its time is proportional to
the length of the subject times the size of the pattern, whatever the pattern: there is no backtracking, so no pattern
can take exponential time (no ReDoS). Among the matches that start at the leftmost position it picks the one Perl or
Python would find first, and on the syntax it supports it gives the same results as Python's `re` with `re.ASCII`.

<<< @/examples/snippets/regex_tour-search.f90

<<< @/examples/output/regex_tour.ansi{ansi}

## Compiling

`call re%compile(pattern[, flags][, iostat][, iomsg])` parses and compiles the pattern. `flags` holds letters:

| Flag | Meaning |
|---|---|
| `i` | ASCII letters match regardless of case |
| `m` | multiline: `^` and `$` also match at the start and the end of every line |
| `s` | the dot also matches a line feed |

The flags can also start the pattern, as `(?im)`. A malformed pattern sets `iostat` to the byte position of the error
and `iomsg` to what is wrong, and leaves the regex not compiled (it then matches nothing); without `iostat` the program
stops with the message.

<<< @/examples/snippets/regex_tour-errors.f90

Limits, beyond which the pattern is a compile error and never a crash: groups nested 200 deep, counts `{m,n}` up to
1000, 1000 capturing groups, a compiled program of 100000 instructions (`(a{1000}){1000}` is too large).

## Matching

| Method | Returns |
|---|---|
| `search(subject[, start])` | the leftmost match from the byte `start` (default 1) |
| `match(subject[, start])` | a match starting at `start` only |
| `fullmatch(subject[, start])` | a match from `start` to the end of the subject |
| `finditer(subject[, start])` | all the matches, left to right, as an array |
| `findall(subject[, group])` | the text of a group of every match (default: group 1 if there is exactly one, else 0) |
| `split(subject[, maxsplit])` | the pieces between the matches, with the texts of the groups between them |
| `sub(repl, subject[, count][, nsub][, iostat][, iomsg])` | the subject with the matches replaced by the template `repl` |

The subject is a `character` or a `string`. A match, `type(regex_match)`, has `found`, `span(group)` (the first and the
last byte, `[0, -1]` for a group that did not match, `[p, p-1]` for an empty one at `p`), `group(group)` (its text, a not
allocated string if the group did not match) and `groups()`; a group is a number (0 is the whole match) or a name.

<<< @/examples/snippets/regex_tour-all.f90

<<< @/examples/snippets/regex_tour-sub.f90

In the template of `sub`, `\1` to `\99`, `\g<n>` and `\g<name>` are the text of a group and `\g<0>` the whole match (a
group that did not match gives nothing); `\n \t \r \f \v \a \b \\` are escapes; a backslash before an ASCII letter
that is not one of these is an error, before anything else it stays. `nsub` returns the number of replacements (Python
`subn`), `count` limits it.

The module procedures `re_search`, `re_fullmatch`, `re_findall`, `re_split` and `re_sub` take the subject first and
the pattern, as a character (compiled at each call, a malformed one stops the program) or as a compiled `regex`; they
are not methods of `string` because `stringifor_regex` builds on the `string` type.

## Syntax

| Construct | Matches |
|---|---|
| a character | itself; a multibyte UTF-8 character is one unit |
| `.` | any character but a line feed (any with `s`) |
| `[abc]`, `[a-z]`, `[^...]` | a character in the set, in a range of codepoints, not in the set; `]` first and `-` first or last are literal |
| `\d \w \s` | ASCII digit, letter, digit or underscore, whitespace (`[ \t\n\r\f\v]`) |
| `\D \W \S` | anything else, including the non-ASCII characters |
| `\t \n \r \f \v \a` | the control characters; `\b` is backspace inside a set |
| `\xHH` | the character U+00HH below 80, **the byte HH** from 80 up |
| `\uXXXX`, `\UXXXXXXXX` | the character of that codepoint |
| `\` and any other character but an ASCII letter or a digit | that character |
| `^`, `$` | start of the subject; end of the subject or before a line feed ending it (with `m`: of any line) |
| `\A`, `\z` (`\Z`) | start, end of the subject |
| `\b`, `\B` | a boundary between an ASCII word character and anything else, and its opposite |
| `(...)`, `(?P<name>...)`, `(?:...)` | a group: numbered, named and numbered, not capturing |
| `x\|y` | `x` or else `y` |
| `* + ?` | 0 or more, 1 or more, 0 or 1 times |
| `{m}`, `{m,}`, `{,n}`, `{m,n}` | m times, at least m, at most n, m to n; a `{` that is not one of these is literal |
| a quantifier followed by `?` | lazy: as few times as possible |

The grammar, in EBNF:

```ebnf
pattern       = [ "(?" flag { flag } ")" ] alternation ;
alternation   = concatenation { "|" concatenation } ;
concatenation = { repeat } ;
repeat        = atom [ quantifier [ "?" ] ] ;
quantifier    = "*" | "+" | "?" | "{" [ count ] [ "," [ count ] ] "}" ;
atom          = "(" [ "?:" | "?P<" name ">" ] alternation ")" | "[" [ "^" ] item { item } "]"
              | "." | "^" | "$" | escape | character ;
item          = ( character | escape ) [ "-" ( character | escape ) ] | class-escape ;
flag          = "i" | "m" | "s" ;
```

Not supported (a compile error): backreferences `\1`, lookahead and lookbehind, possessive quantifiers, atomic groups,
recursion, conditionals, scoped flags `(?i:...)`, octal escapes. These are the features that require backtracking.

## Characters, bytes and UTF-8

The regexes work on units, as the rest of the library: a well-formed UTF-8 sequence is one character, a byte that is
not part of one is one unit of its own. So `.` and `[^a]` match a whole `é` or `😀`, a range `[à-ÿ]` compares
codepoints, and an ill-formed byte is matched by `.`, by a negated set and by `\xHH`. Positions are always in bytes, so
`span` can slice `raw`. Case folding (`i`) and the classes `\d \w \s` are ASCII, as with Python's `re.ASCII`.

## Matches and empty matches

`finditer`, `findall`, `split` and `sub` follow Python: after a match the search goes on where it ended; an empty match
is allowed right after a non-empty one, but not right after another empty one at the same position. So `x*` in `axb`
matches empty at 1, `x` at 2, empty at 3 and empty at 4, and `re%sub('-', 'axb')` gives `-a--b-`.

A repetition whose body can match empty stops after an empty iteration and keeps the groups of that iteration, as
Python does: `(a|)*` on `aa` leaves group 1 empty at byte 3.

## Differences from Python

On the supported syntax the results are those of Python's `re` with `re.ASCII`, on the subject decoded with
`surrogateescape`: this is checked on random patterns and subjects (`bash scripts/oracle.sh regex`). The differences:

- `\xHH` from 80 up is a byte, as in `unescape_c`; Python's is the character U+00HH (write `é` for `é`).
- Patterns that need backtracking are rejected, as listed above; `\u` of a surrogate is rejected.
- `findall` with two or more groups returns one group (`group=`, default the whole match), not tuples.
- Templates of `sub` reject the octal escapes (`\0`, `\123`).
- `$`, `\b` and the classes are ASCII only, as `re.ASCII`.

## Performance

The time is linear in the subject: `scripts/utf8/src/regex_scaling.f90` searches patterns that are exponential for a
backtracking engine, as `(a*)*b` and `(a|aa)*c`, in up to 10⁵ bytes they do not match, and the time per byte stays
constant (40 to 110 ns per byte on a desktop CPU). A backtracking engine does not finish them.
