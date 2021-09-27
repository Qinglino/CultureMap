# CultureMap
Based on World Values Survey (Wave 6), this project selects 50 questions as variables and conducts a PCA to reduce the number of dimensions to only two, thus drawing a cultural map.

Creating the data set
------------------
The key task in data cleaning process is to select a large number (>50) of variables that measure values in an ordered way. It can be tedious to select the questions manually, but it is easier to pick out questions based on the texts of choices. After scrutinizing the questionnaire, I select the questions that contain the key words "very", "strongly", "completely", "extremely" etc. in their choice texts, which give me 222 questions in total.
I calculate country mean of the 222 questions exlcuding the missing values, after which I only preserve questions that have a valid mean for every country. A total of 89 questions are left. Manual normalization is optional since later on in the Principal Component Analysis, it will be implemented automaticallly. Still, normalization is important in our case, as the scales are different.

Analysis
------------------
First we take a look at how questions covary. Cluster 1 in red dots is about cons of science(e.g. V194-V196), mercy on misbahaviour (e.g. V200, V202) and rule of man(e.g. V132, V138), so I would label this cluster as "Individual-oriented". Cluster 2 in green triangles is about lack confidence in authority (e.g. V113, V114, V115, V119, V120), so I label it as "Anarchist". Cluster 3 in cyan squares is about family (e.g. V182-V184, V49), living conditions(e.g. V71, V72, V75), and I tend to label it as "Family-oriented". Cluster 4 in purple, however, is about supply of living necessities (e.g. V188-V190), security (e.g. V171, V173), hence, I label it as "Authoritarian". I must acknowledge these labels can be narrow to a great extent, but they do reflect on some key features of the questionnaire. 

![image text](https://github.com/Qinglino/CultureMap/blob/main/Analysis/Output/question_cluster_norm.png)

Then we can see that it is quite clear that all 60 countries are seperated into two groups. The pattern here is also straight forward that the ones in red are more developed than the ones in cyan. Note that the first and the second principal components can only explain around 40% of total variations.
![image text](https://github.com/Qinglino/CultureMap/blob/main/Analysis/Output/country_cluster_norm.png)

The cultrue map is also presented below. Although this is not very similar to the one given by Inglehart–Welzel, it still shows a pretty clear clustering pattern across different regions and cultural backgrounds. 

![image text](https://github.com/Qinglino/CultureMap/blob/main/Analysis/Output/culturemap.png)
