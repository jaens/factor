! Copyright (C) 2007, 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: words words.symbol sequences vocabs kernel
compiler.units ;
IN: bootstrap.syntax

[
    "syntax" create-vocab drop

    {
        "("
        ":"
        ";"
        "--"
        "`" "``" "```" "````"
        "$\\"
        "![[" "![=[" "![==["
        "[[" "[=[" "[==["
        "factor[[" "factor[=[" "factor[==["
        "factor\""
        "resource\"" "vocab\"" "home\""
        "resource`" "vocab`" "home`"
        "PRIVATE<"
        "B{"
        "BV{"
        "C:"
        "char:"
        "ARITY:"
        "LEFT-DECORATOR:"
        "DEFER:"
        "ERROR:"
        "FORGET:"
        "GENERIC#:"
        "GENERIC:"
        "HOOK:"
        "H{"
        "HS{"
        "IN:"
        "INSTANCE:"
        "M:"
        "MAIN:"
        "MATH:"
        "MIXIN:"
        "nan:"
        "POSTPONE\\"
        "postpone\\"
        "\\"
        "M\\"
        "PREDICATE:"
        "PRIMITIVE:"
        "PRIVATE>"
        "SINGLETON:"
        "SINGLETONS:"
        "BUILTIN:"
        "SYMBOL:"
        "SYMBOLS:"
        "CONSTANT:"
        "TUPLE:"
        "SLOT:"
        "T{"
        "UNION:"
        "INTERSECTION:"
        "USE:"
        "UNUSE:"
        "USING:"
        "QUALIFIED:"
        "QUALIFIED-WITH:"
        "FROM:"
        "EXCLUDE:"
        "RENAME:"
        "ALIAS:"
        "SYNTAX:"
        "V{"
        "W{"
        "["
        "]"
        "delimiter"
        "deprecated"
        "f"
        "flushable"
        "foldable"
        "inline"
        "recursive"
        "final"
        "@delimiter"
        "@deprecated"
        "@flushable"
        "@foldable"
        "@inline"
        "@recursive"
        "@final"
        "t"
        "{"
        "}"
        "CS{"
        "<<" ">>"
        "COMPILE<" "COMPILE>"
        "call-next-method"
        "not{"
        "maybe{"
        "union{"
        "intersection{"
        "initial:"
        "read-only"
        "call("
        "execute("
        "execute\\"
        "\""
        "P\""
        "SBUF\""

        "::" "M::" "MEMO:" "MEMO::" "MACRO:" "MACRO::" "IDENTITY-MEMO:" "IDENTITY-MEMO::" "TYPED:" "TYPED::"
        "set:" "|[" "let[" "MEMO["
        "$["
        "_"
        "@"
        "IH{"
        "PROTOCOL:"
        "CONSULT:"
        "BROADCAST:"
        "SLOT-PROTOCOL:"
        "HINTS:"
    } [ "syntax" create-word drop ] each

    "t" "syntax" lookup-word define-symbol
] with-compilation-unit
