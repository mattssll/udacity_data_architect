import pyspark
sc = pyspark.SparkContext('local[*]')
text_file = sc.textFile("./input_data/README.md")
wordRdd = text_file. \
		flatMap(lambda row: row.split(" ")). \
		map(lambda word : (word, 1))
counts = wordRdd.reduceByKey(lambda a, b : a + b)
# doing this since we can only sort by keys
counts_swapped_to_filter = counts.map(lambda x: (x[1], x[0]))
# false argument in used to control sort order
counts_sorted = counts_swapped_to_filter.sortByKey(False)
counts_filtered = counts_sorted.filter(lambda x : x[0] > 5)
results = counts.collect()
for item in results:
	print(item)
counts_filtered.saveAsTextFile("WordCountResults")