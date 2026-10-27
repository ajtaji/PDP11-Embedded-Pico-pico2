sort <words >sort.$$
od sort.$$ | sort -n +1 >od.$$
grep the sort.$$ | tee grep.$$ | wc >wc.$$
cat wc.$$
rm sort.$$ grep.$$ od.$$ wc.$$
