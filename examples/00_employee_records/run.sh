#!/bin/bash

echo "Employers who worked:"

goawk '!/^#/ && $3 > 0 { print $1, $2 * $3 }' emp.data

echo ; echo "Employers who did NOT work:"

goawk '!/^#/ && $3 == 0 { print $1, $2 * $3 }' emp.data

echo ; echo "All employers with words:"

goawk '!/^#/ { print "total pay for", $1, "is", $2 * $3 }' emp.data

echo ; echo "All employers with fancy output:"

goawk '!/^#/ { printf("total pay for %s is $%.2f\n", $1, $2 * $3) }' emp.data

echo ; echo "All employers with fixed width:"

goawk '!/^#/ { printf("%-8s $%6.2f\n", $1, $2 * $3) }' emp.data

echo ; echo "Employers who earn 5 or more per hour:"

goawk '!/^#/ && $2 >= 5' emp.data

echo ; echo "Prints the pay of those employees whose total pay exceeds 50:"

goawk '!/^#/ && $2 * $3 > 50 { printf("$%.2f for %s\n", $2 * $3, $1) }' emp.data

echo ; echo "Count employees who have worked more than 15 hours:"

goawk -f count.awk emp.data

echo ; echo "Compute the average pay:"

egrep -v '^#' emp.data | goawk -f average_pay.awk

echo ; echo "Finds the employee who is paid the most per hour:"

goawk -f highest_rate.awk emp.data

echo ; echo "wc:"

goawk -f wc.awk emp.data

echo ; echo "Average pay over 6:"

goawk -f average_pay_over_6.awk emp.data

echo ; echo "Reverse with while:"

goawk -f reverse.awk emp.data

echo ; echo "Reverse with for:"

goawk -f reverse_for.awk emp.data
