# WORKING WITH JSONs - SENDING DATA TO STAGING
# First split big jsons in linux terminal
split -l 500000 yelp_academic_dataset_review.json yelp_reviews
split -l 500000 yelp_academic_dataset_user.json yelp_user
# use wildcard in file name
put file:///Users/mateus.leao/Documents/mattssll/courses/data-architect-udacity/Project2.Data_Warehouses/data/yelp_dataset/yelp_academic_dataset_covid_features.json @my_json_stage auto_compress=true;
put file:///Users/mateus.leao/Documents/mattssll/courses/data-architect-udacity/Project2.Data_Warehouses/data/yelp_dataset/yelp_academic_dataset_business.json @my_json_stage auto_compress=true;
put file:///Users/mateus.leao/Documents/mattssll/courses/data-architect-udacity/Project2.Data_Warehouses/data/yelp_dataset/yelp_academic_dataset_tip.json @my_json_stage auto_compress=true;
put file:///Users/mateus.leao/Documents/mattssll/courses/data-architect-udacity/Project2.Data_Warehouses/data/yelp_dataset/yelp_academic_dataset_checkin.json @my_json_stage auto_compress=true;
put file:///Users/mateus.leao/Documents/mattssll/courses/data-architect-udacity/Project2.Data_Warehouses/data/yelp_dataset/split_yelp_academics_dataset_user/yelp_user*.json @my_json_stage auto_compress=true;
put file:///Users/mateus.leao/Documents/mattssll/courses/data-architect-udacity/Project2.Data_Warehouses/data/yelp_dataset/split_yelp_academics_dataset_review/yelp_reviews*.json @my_json_stage auto_compress=true;
# Press enter. If you see uploaded that means the command ran successfully. 
# Note: We compressed the file to speed up the upload.
# Now finally copy the data you just uploaded directly into the table created in the previous steps,
copy into yelp_academic_dataset_review from @my_json_stage/ pattern = '.*yelp_review.*';
copy into yelp_academic_dataset_user from @my_json_stage/ pattern = '.*yelp_user.*';
copy into yelp_academic_dataset_checkin from @my_json_stage/yelp_academic_dataset_checkin.json.gz;
copy into yelp_academic_dataset_tip from @my_json_stage/yelp_academic_dataset_tip.json.gz;
copy into yelp_academic_dataset_business from @my_json_stage/yelp_academic_dataset_business.json.gz;
copy into yelp_academic_dataset_covid_features from @my_json_stage/yelp_academic_dataset_covid_features.json.gz;
# JSON Data is in staging after the above
# SEND DATA FROM STAGING TO ODS - creating pks, fks, etc
