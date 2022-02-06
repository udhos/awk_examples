# awk_examples

    git clone https://github.com/benhoyt/goawk
    cd goawk
    go install

# Book

[The AWK Programming Language - PDF](https://ia803404.us.archive.org/0/items/pdfy-MgN0H1joIoDVoIC7/The_AWK_Programming_Language.pdf)

[The AWK Programming Language - HTML](https://nextjournal.com/btowers/the-awk-programming-language)

# Hints

There are only two types of data in awk: numbers and strings of characters.

The first field in the current input line is called $1, the second $2, and so forth. The entire line is called $0.

`{ print }`  does the same as `{ print $0 }`

Expressions separated by a comma in a print statement are, by default, separated by a single blank when they are printed.

    $ echo 'hello    big      world' | goawk '{ print $1, $3 }'
    hello world

Any expression can be used after $ to denote a field number.

    $1:     the first field
    $(1+1): the second field
    $N:     takes the field index from variable N
    $NF:    the last field (NF is a built-in variable with the number of fields in the current input line)

Print the first and last fields:

    $ echo a b c d | goawk '{ print $1, $NF }'
    a d

NR is a built-in variable with the number of records read so far.

Prefix each line with its line number:

    $ head -5 /etc/passwd | goawk '{ print NR, $0 }'
    1 root:x:0:0:root:/root:/bin/bash
    2 daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
    3 bin:x:2:2:bin:/bin:/usr/sbin/nologin
    4 sys:x:3:3:sys:/dev:/usr/sbin/nologin
    5 sync:x:4:65534:sync:/bin:/bin/sync

Patterns can be combined with parentheses and the logical operators &&, ||, and !, which stand for AND, OR, and NOT.

    $2 >= 4 || $3 >= 20 || /Susie/ || $1 == "John"

Lines that satisfy both conditions are printed only once:

    $ printf "line1\nline2\nline3\n" | goawk '/line2/ || /2/'
    line2

Contrast this with the following program, which consists of two patterns:

    $ cat > /tmp/prog.awk
    /line2/
    /2/
    $ printf "line1\nline2\nline3\n" | goawk -f /tmp/prog.awk
    line2
    line2

Program for data validation:

    NF I= 3 { print $0, "number of fields is not equal to 3" }
    $2 < 3.35 { print SO, "rate is below minimum wage" }
    $2 > 10 { print $0, "rate exceeds $10 per hour" }
    $3 < 0 { print $0, "negative hours worked" }
    $3 > 60 { print $0, "too many hours worked" }

The special pattern BEGIN matches before the first line of the first input file is read, and END matches after the last line of the last file has been processed. This program uses BEGIN to print a heading:

    BEGIN { print "NAME RATE HOURS"; print "" }
          { print }

You can put several statements on a single line if you separate them by semicolons.

    print    --> print current input line
    print $0 --> print current input line
    print "" --> print blank line

Count employees who have worked more than 15 hours:

    $3 > 15 { emp = emp + 1 }
    END     { print emp, "employees worked more than 15 hours" }

In awk, user-created variables are not declared.

Awk variables used as numbers begin life with the value 0, so we didn't need to initialize emp.

*** Handling Text
