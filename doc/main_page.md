---
project: StringiFor
src_dir: ../src/lib
src_dir: ../src/tests
src_dir: ../src/third_party/PENF/src/lib
src_dir: ../src/third_party/BeFoR64/src/lib

output_dir: html/publish/
project_github: https://github.com/szaghi/StringiFor
project_download: https://github.com/szaghi/StringiFor/releases/latest
summary: Strings Fortran Manipulator, yet another strings Fortran module
author: Stefano Zaghi
github: https://github.com/szaghi
email: stefano.zaghi@gmail.com
md_extensions: markdown.extensions.toc(anchorlink=True)
               markdown.extensions.smarty(smart_quotes=False)
               markdown.extensions.extra
               markdown_checklist.extension
docmark: <
display: public
         protected
         private
source: true
warn: true
graph: true
sort: alpha
print_creation_date: true
creation_date: %Y-%m-%d %H:%M %z
extra_mods: iso_fortran_env:https://gcc.gnu.org/onlinedocs/gfortran/ISO_005fFORTRAN_005fENV.html

{!../README.md!}
---
