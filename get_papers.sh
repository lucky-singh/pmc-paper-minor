#Create folder structure and change directory
mkdir -p ~/paper/single_row ~/paper/relevent ~/paper/source
cd ~/paper/source

##Download all archived papers from pmc ftp server in txt versions
curl -O ftp://ftp.ncbi.nlm.nih.gov/pub/pmc/articles.0-9A-B.txt.tar.gz
curl -O ftp://ftp.ncbi.nlm.nih.gov/pub/pmc/articles.C-H.txt.tar.gz
curl -O ftp://ftp.ncbi.nlm.nih.gov/pub/pmc/articles.I-N.txt.tar.gz
curl -O ftp://ftp.ncbi.nlm.nih.gov/pub/pmc/articles.O-Z.txt.tar.gz

##Extract the zip files, make a copy and convert all files into single line
tar -xzf articles.*.gz 2>/dev/null
find . -type d | xargs -I% rsync -a '%' ~/paper/single_row/
cd ~/paper/single_row/
find . -type f | xargs sed -i ':a;N;$!ba;s/\n/ /g'

#Create 1st three letters buckets to evenly distribute search pattern and run in parallal.
ls ~/paper/single_row/ | cut -c1-3 | sort -u > ~/paper/first_three_letters.txt
cat ~/paper/first_three_letters.txt | xargs -I{} echo "egrep -iro '.{0,250}((ios|android|(mobile|smart) ?phones?|mobiles?) apps?lications?|(play|apps?) ?stores?).{0,250}' ~/paper/single_row/{}* > ~/paper/relevent/papers_name_with_pattern_{}.txt &" | sort -u > ~/paper/run_search_patterns.sh
bash ~/paper/run_search_patterns.sh
