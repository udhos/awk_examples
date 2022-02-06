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

Variables used to store strings begin life holding the null string (that is, the string containing no characters).

The concatenation operation is represented in an awk program by writing string values one after the other.

This program collects all the employee names into a single string, by appending each name and a blank to the previous value in the variable names. 

          { names = names $1 " " }
    END   { print names }

Although NR retains its value in an END action, $0 does not. One way to print the last input line:

        { last = $0 }
    END { print last }

length is a built-in function which counts the number of characters in a string.

Printing the length of each line:

    { print length($0) }

Counting Lines, Words, and Characters:

        {
            nc = nc + length($0) + 1
            nw = nw + NF
        }
    END { print NR, "lines,", nw, "words,", nc, "characters" }

The following program computes the total and average pay of employees making more than $6.00 an hour. It uses an if to defend against division by zero in computing the average pay.

    !/^#/ && $2 > 6 { n = n + 1; pay = pay + $2 * $3 }
    END             {
                        if (n > 0)
                            print n, "employees, total pay is", pay,
                                "average pay is", pay/n
                        else
                            print "no employees are paid more than $6/hour"
                    }

Awk provides arrays for storing groups of related values. The following program prints its input in reverse order by line.

    # reverse - print input in reverse order by line

        { line[NR] = $0 }   # remember each input line

    END {
            i = NR          # print lines in reverse order
            while (i > 0) {
                print line[i]
                i = i - 1
            }
        }

Reverse with FOR:

    # reverse - print input in reverse order by line

        { line[NR] = $0 }  # remember each input line
    END {
            for (i = NR; i > 0; i = i - 1)
                print line[i]
        }

Print the total number of input lines:

    END { print NR }

Print the tenth input line:

    NR == 10

Print the last field of every input line:

    { print $NF }

Print the last field of the last input line:

        { field = $NF }
    END { print field }

Print every input line with more than four fields:

    NF > 4

Print every input line in which the last field is more than 4:

    $NF > 4

Print the total number of fields in all input lines:

        { nf = nf + NF }
    END { print nf }

Print the total number of lines that contain Beth:

    /Beth/ { nlines = nlines + 1 }
    END    { print nlines }

Print the largest first field and the line that contains it (assumes some $1 is positive):

    $1 > max { max = $1; maxline = $0 }
    END      { print max, maxline }

Print every line that has at least one field:

    NF > 0

Print every line longer than 80 characters:

    length($0) > 80

Print the number of fields in every line followed by the line itself:

    { print NF, $0 }

Print the first two fields, in opposite order, of every line:

    { print $2, $1 }

Exchange the first two fields of every line and then print the line:

    $ echo 'a   b   c   d' | goawk '{ temp = $1; $1 = $2; $2 = temp; print }'
    b a c d

Print every line with the first field replaced by the line number:

    { $1 = NR; print }

Print every line after erasing the second field:

    $ echo 'a    b    c    d' | goawk '{ $2 = ""; print }'
    a  c d

Print in reverse order the fields of every line:

    {
        for (i = NF; i > 0; i = i - 1) printf("%s ", $i)
        printf ( "\n" )
    }

Print the sums of the fields of every line:

    {
        sum = 0
        for (i = 1; i <= NF; i = i + 1) sum = sum + $i
        print sum
    }

Add up all fields in all lines and print the sum:

        { for (i = 1; i <= NF; i = i + 1) sum = sum + $i }
    END { print sum }

Print every line after replacing each field by its absolute value:

    {
        for (i = 1; i <= NF; i = i + 1) if ($i < 0) $i = -$i
        print
    }

