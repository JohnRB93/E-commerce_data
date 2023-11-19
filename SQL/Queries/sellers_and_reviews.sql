-- What is the mean and median of each of the review scores?

SELECT
	TOP 1 PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY Five_Star_Reviews) OVER() AS median_num_five_star_reviews,
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY Four_Star_Reviews) OVER() AS median_num_four_star_reviews,
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY Three_Star_Reviews) OVER() AS median_num_three_star_reviews,
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY Two_Star_Reviews) OVER() AS median_num_two_star_reviews,
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY One_Star_Reviews) OVER() AS median_num_one_star_reviews
FROM sellers;

SELECT
	AVG(Five_Star_Reviews) AS avg_num_five_star_reviews,
    AVG(Four_Star_Reviews) AS avg_num_four_star_reviews,
    AVG(Three_Star_Reviews) AS avg_num_three_star_reviews,
    AVG(Two_Star_Reviews) AS avg_num_two_star_reviews,
    AVG(One_Star_Reviews) AS avg_num_one_star_reviews
FROM sellers;