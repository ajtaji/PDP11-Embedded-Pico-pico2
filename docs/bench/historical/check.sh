sort <words >sorted
od sorted | sort -n +1 >octal
grep the sorted | tee matched | wc >counts
cat sorted
cat matched
cat counts
