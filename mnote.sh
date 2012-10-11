YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)

mkdir -p ~/notes/work/${YEAR}/${MONTH}
vi + ~/notes/work/${YEAR}/${MONTH}/$(date +%Y-%m-%d).txt
