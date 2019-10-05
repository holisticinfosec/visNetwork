# Reused from Niklas Junker's Interactive Network Visualization with R 
# https://www.statworx.com/de/blog/interactive-network-visualization-with-r/
# Via STATWORX: https://twitter.com/statworx

# Remove all the objects from the workspace (clear the chaff), and set the working directory

rm(list = ls())
setwd("c:/coding/R/visNetwork")

#Load the required packages

library(dplyr)
library(visNetwork)
library(geomnet)
library(igraph)

# Data Preparation

#Load dataset

# Load nodes data from CSV
nodeData <- read.csv("nodes.csv", header = TRUE)
nodes <- as.data.frame(nodeData)

# Load edges from CSV
edgeData <- read.csv("edges.csv", header = TRUE)
edges <- as.data.frame(edgeData)

# Create graph for Louvain Community Detection (LCD)
# https://arxiv.org/pdf/0803.0476.pdf

graph <- graph_from_data_frame(edges, directed = FALSE)

#Louvain Community Detection (LCD)

cluster <- cluster_louvain(graph)

cluster_df <- data.frame(as.list(membership(cluster)))
cluster_df <- as.data.frame(t(cluster_df))
cluster_df$label <- rownames(cluster_df)

#Create group column

nodes <- left_join(nodes, cluster_df, by = "label")
colnames(nodes)[3] <- "group"

# Visualize data with visNetwork

visNetwork(nodes, edges)

# Customize network with functions such as visNodes,  visEdges, visOptions, visLayout or visIgraphLayout

visNetwork(nodes, edges, width = "100%") %>%
  visIgraphLayout() %>%
  visNodes(
    shape = "dot",
    color = list(
      background = "#0085AF",
      border = "#013848",
      highlight = "#FF8000"
    ),
    shadow = list(enabled = TRUE, size = 10)
  ) %>%
  visEdges(
    shadow = FALSE,
    color = list(color = "#0085AF", highlight = "#C62F4B")
  ) %>%
  visOptions(highlightNearest = list(enabled = T, degree = 1, hover = T),
             selectedBy = "group") %>% 
  visLayout(randomSeed = 11)