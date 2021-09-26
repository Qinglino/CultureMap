countrylist <- country_mean$country
regionlist <- country_mean$region

pca_process <- function(mean, if_norm){
  # set file path and name
  suffix <- if_else(if_norm == 1, "_norm.png", ".png")
  path <- "./Analysis/Output/"
  
  #get PCA scores
  pca_score <- principal(mean, 2)$scores %>% 
    as.data.frame() %>% 
    mutate(region = regionlist)
  rownames(pca_score) <- countrylist
  
  #get PCA loadings
  pca_loading <- principal(mean, 2)$loadings[,] %>% 
    as.data.frame() 
  
  
  #fviz_nbclust(pca_loading, kmeans, method = "silhouette"), optimal #cluster = 4
  kmeans(pca_loading, centers = 4, nstart = 25) %>% 
    fviz_cluster(data = pca_loading,
                 pointsize = 3,
                 labelsize = 12, 
                 repel = TRUE,
                 main = "Question Clusters by k-means (k = 4)") 
  ggsave(paste(path, "qustion_cluster", suffix, sep = ""), 
         width = 13, height = 8)
  
  #fviz_nbclust(pca_score, kmeans, method = "silhouette"), optimal #cluster = 2
  kmeans(pca_score, centers = 2, nstart = 25) %>% 
    fviz_cluster(data = pca_score,
                 pointsize = 3,
                 labelsize = 12, 
                 repel = TRUE, #avoid label overlap
                 main = "Country Clusters by k-means (k = 2)") 
  ggsave(paste(path, "country_cluster", suffix, sep = ""), 
         width = 13, height = 8)
  
  ggplot(data = pca_score, aes(x = RC1, y = RC2, color = region)) +
    geom_point() +
    geom_mark_hull(aes(fill = region, label = region), concavity = 1) +
    theme_light() +
    coord_cartesian(clip = "off")+
    theme(plot.margin = margin(10,10,10,50),
          legend.background = element_blank()) +
    geom_text_repel(data = pca_score,
                    mapping = aes(x = RC1, y = RC2, label = countrylist),
                    size = 4)
    
  # clustering by group, this figure is not very pretty...
  # rc1 <- pca_score$RC1 + runif(n_country, -1, 1)
  # rc2 <- pca_score$RC2 + runif(n_country, -1, 1)
  # data <- as.data.frame(cbind(rc1, rc2, regionlist, countrylist))
  # 
  # ggplot(data, aes(x = rc1, y = rc2, fill = factor(regionlist), group = -1L)) +
  #   geom_voronoi_tile() +
  #   geom_point(shape = factor(regionlist), size = 3) +
  #   theme_light() +
  #   geom_text_repel(data = data,
  #                   mapping = aes(x = rc1, y = rc2, label = countrylist),
  #                   size = 4) # this command from "ggrepel" helps with overlaps
  #   
}

pca_process(country_mean_norm[, 3:n_var+2], 1)# notice that this df contains contains
                                            # questions and group labels 
pca_process(country_mean[, 3:n_var+2], 0)
