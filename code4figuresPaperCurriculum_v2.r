# Works with R version 4.0.3 (2020-10-10) // Duarte, R. // 2020.12.09
# //////////////////////////////// .:§:. \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#
# # # Figure 2 BEGIN // Wordcloud
# # Import the dataset
#setwd('/path/to/folder/where/data4wordcloud.csv/file/is')
# dataset_original5C=read.csv(file='data4wordcloud.csv', sep = ";", stringsAsFactors = FALSE)
# library(tm)
# library(SnowballC)
# # Tokenizing and Normalizing
# corpus5C = VCorpus(VectorSource(dataset_original5C$BroaderTerms))
# corpus5C = tm_map(corpus5C, content_transformer(tolower)) #lowercase
# corpus5C = tm_map(corpus5C, removeNumbers) #numbers
# corpus5C = tm_map(corpus5C, removePunctuation) #punctuation
# corpus5C = tm_map(corpus5C, removeWords, stopwords()) #stopwords
# corpus5C = tm_map(corpus5C, stemDocument) #stemming
# corpus5C = tm_map(corpus5C, stripWhitespace) #remoção de espaços em branco
# # Creating the Bag of Words model
# dtm5C = DocumentTermMatrix(corpus5C)
# uc5C=c(dataset_original5C$C)
# A5C=as.matrix(dtm5C)
# rownames(A5C)<-uc5C
# #------WORLDCLOUD (BEGIN)-------
# # See URL: https://towardsdatascience.com/create-a-word-cloud-with-r-bde3e7422e8a
# library(wordcloud)
# library(RColorBrewer)
# #display.brewer.all()
# words5C <- sort(colSums(A5C),decreasing=TRUE)
# df5C <- data.frame(word = names(words5C),freq=words5C)
# set.seed(1000) # for reproducibility
# my_colors <- RColorBrewer::brewer.pal(9, "Greys")[c(7,7,9)]
# wordcloud(words = df5C$word, freq = df5C$freq, min.freq = 1,
#           max.words=200, random.order=FALSE, rot.per=0.35,
#           colors=my_colors)
#
# # # Figure 2 END
#
# //////////////////////////////// .:§:. \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
# Figure 3 a) BEGIN // Circular ideogram
# Based on code in the R Graph Gallery "Advanced chord diagram with R and circlize"
# URL: https://www.r-graph-gallery.com/122-a-circular-plot-with-the-circlize-package.html
# library(circlize)
# library(repr)
# library(dplyr)
# m <- data.frame(order = 1:11,
#             vertex = c("C1\n ","C2\n ","C3\n ","C4\n ","C5\n ", "K1\n ", "K2\n ", "K3\n ", "K4\n ", "K5\n ", "K6\n "),
#             V3 = c(0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 0),
#             V4 = c(0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0),
#             V5 = c(0, 0, 0, 0, 0, 2, 0, 2, 1, 1, 2),
#             V6 = c(0, 0, 0, 0, 0, 3, 0, 1, 2, 0, 1),
#             V7 = c(0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0),
#             V8 = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#             V9 = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#             V10 = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#             V11 = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#             V12 = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#             V13 = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#             r = c(255, 255, 255, 255, 153, 153, 153, 153, 51, 51, 51),
#             g = c(153, 153, 51, 51, 153, 153, 51, 51, 153, 153, 51),
#             b = c(153, 51, 153, 51, 153, 51, 153, 51, 153, 51, 153),
#             stringsAsFactors = FALSE)
# ### Create a data frame
# df1 <- m[, c(1,2, 14:16)]
# ### Create a matrix
# m <- m[,-(1:2)]
# m <- as.matrix(m[,c(1:11)])
# dimnames(m) <- list(orig = df1$vertex, dest = df1$vertex)
# ### Sort order of data.frame and matrix for plotting in circos
# df1 <- arrange(df1, order)
# df1$vertex <- factor(df1$vertex, levels = df1$vertex)
# m <- m[levels(df1$vertex),levels(df1$vertex)]
# ### Define ranges of circos sectors and their colors (both of the sectors and the links)
# df1$xmin <- 0
# df1$xmax <- rowSums(m) + colSums(m)
# n <- nrow(df1)
# df1$rcol<-rgb(df1$r, df1$g, df1$b, max = 255)
# df1$lcol<-rgb(df1$r, df1$g, df1$b, alpha=200, max = 255)
#
# ##
# ## Plot sectors (outer part)
# ##
# circos.clear()
# ### Basic circos graphic parameters
# circos.par(cell.padding=c(0,0,0,0), track.margin=c(0,0.15), start.degree = 90, gap.degree =4)
# ### Sector details
# circos.initialize(factors = df1$vertex, xlim = cbind(df1$xmin, df1$xmax))
# ### Plot sectors
# circos.trackPlotRegion(ylim = c(0, 1), factors = df1$vertex, track.height=0.1,
#                       #panel.fun for each sector
#                       panel.fun = function(x, y) {
#                       #select details of current sector
#                       name = get.cell.meta.data("sector.index")
#                       i = get.cell.meta.data("sector.numeric.index")
#                       xlim = get.cell.meta.data("xlim")
#                       ylim = get.cell.meta.data("ylim")
#
#                       #text direction (dd) and adjusmtents (aa)
#                       theta = circlize(mean(xlim), 1.3)[1, 1] %% 360
#                       dd <- ifelse(theta < 90 || theta > 270, "clockwise", "reverse.clockwise")
#                       aa = c(1, 0.5)
#                       if(theta < 90 || theta > 270)  aa = c(0, 0.5)
#
#                       #plot vertex labels
#                       circos.text(x=mean(xlim), y=2.0, labels=name, facing = dd, cex=2.0,  adj = aa)
#
#                       #plot main sector
#                       circos.rect(xleft=xlim[1], ybottom=ylim[1], xright=xlim[2], ytop=ylim[2],
#                                   col = df1$rcol[i], border=df1$rcol[i])
#
#                       #blank in part of main sector
#                       circos.rect(xleft=xlim[1], ybottom=ylim[1], xright=xlim[2]-rowSums(m)[i], ytop=ylim[1]+0.3,
#                                   col = "white", border = "white")
#
#                       #white line all the way around
#                       circos.rect(xleft=xlim[1], ybottom=0.3, xright=xlim[2], ytop=0.32, col = "white", border = "white")
#
#                       #plot axis
#                       circos.axis(labels.cex=1.5, direction = "outside", major.at=seq(from=0,to=floor(df1$xmax)[i],by=2),
#                                   minor.ticks=1, labels.away.percentage = 0.15)
#                     })
#
# ##
# ## Plot links (inner part)
# ##
# df1$sum1 <- colSums(m)
# df1$sum2 <- numeric(n)
#
# ### Create a data.frame of the flow matrix sorted by flow size, to allow largest flow plotted first
# df2 <- cbind(as.data.frame(m),orig=rownames(m),  stringsAsFactors=FALSE)
# df2 <- reshape(df2, idvar="orig", varying=list(1:n), direction="long", timevar="dest", time=rownames(m),  v.names = "m")
# df2 <- arrange(df2,desc(m))
#
# ### Keep only the largest flows to avoid clutter
# df2 <- subset(df2, m > quantile(m,0.6))
#
# ### Plot links
# match(df2$orig[1],df1$vertex)
# for(k in 1:nrow(df2)){
#     #i,j reference of flow matrix
#     i<-match(df2$orig[k],df1$vertex)
#     j<-match(df2$dest[k],df1$vertex)
#
#     #plot link
#     circos.link(sector.index1=df1$vertex[i], point1=c(df1$sum1[i], df1$sum1[i] + abs(m[i, j])),
#             sector.index2=df1$vertex[j], point2=c(df1$sum2[j], df1$sum2[j] + abs(m[i, j])),
#             col = ifelse(abs(m[i, j]) < 1, "#FFFFFF00", df1$lcol[i]))
#
#     #update sum1 and sum2 for use when plotting the next link
#     df1$sum1[i] = df1$sum1[i] + abs(m[i, j])
#     df1$sum2[j] = df1$sum2[j] + abs(m[i, j])
# }
#
# Figure 3 a) END
#
# //////////////////////////////// .:§:. \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#
# # # Figure 3 b) BEGIN // Multigraph
# library(igraph)
# Aa<-rbind(c(0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 0),
#         c(0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0),
#         c(0, 0, 0, 0, 0, 2, 0, 2, 1, 1, 2),
#         c(0, 0, 0, 0, 0, 3, 0, 1, 2, 0, 1),
#         c(0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0),
#         c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#         c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#         c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#         c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#         c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
#         c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
#         )
# rownames(Aa) <- c("C1", "C2", "C3", "C4", "C5","K1", "K2", "K3", "K4", "K5","K6")
# colnames(Aa) <- c("C1", "C2", "C3", "C4", "C5","K1", "K2", "K3", "K4", "K5","K6")
# Aa[lower.tri(Aa,diag=TRUE)] <- 0
# networkAa <- graph_from_adjacency_matrix(Aa, mode="undirected")
# degAa <- igraph::degree(networkAa, mode="all")
# V(networkAa)$label.cex=1.0
# V(networkAa)$label.dist[1:5]=rep(0.,5)
# V(networkAa)$label.degree[1:5]=rep(0.,5)
# V(networkAa)$label.dist[6]=2.0
# V(networkAa)$label.degree[6]=0
# V(networkAa)$label.dist[9]=2.0
# V(networkAa)$label.degree[9]=pi
# V(networkAa)$label.dist[7:8]=rep(1.0,2)
# V(networkAa)$label.degree[7:8]=rep(-pi/2.,2)
# V(networkAa)$label.dist[10:11]=rep(1.5,2)
# V(networkAa)$label.degree[10:11]=rep(0.,2)
# V(networkAa)$label.color = adjustcolor("black", 1.0)
# V(networkAa)$color[1:5]=rep(adjustcolor("SkyBlue2", alpha.f = .33),5)
# V(networkAa)$color[6:11]=rep(adjustcolor("bisque", alpha.f = .33),6)
# V(networkAa)$size[1:5]=degAa*4
# V(networkAa)$size[6:11]=5
# V(networkAa)$frame.color[1:5]=rep(adjustcolor("SkyBlue2", alpha.f = .0),5)
# V(networkAa)$frame.color[6:11]=rep(adjustcolor("black", alpha.f = .1),6)
# #coordsAaa <- layout.fruchterman.reingold(networkAa)
# coordsAa=rbind(
#   c(6.660312,	8.534405),
#   c(7.793377,	11.094808),
#   c(5.154690,	5.069169),
#   c(4.584851,	4.064317),
#   c(5.394312,	1.913341),
#   c(5.166727,	3.557937),
#   c(7.203729,	9.752555),
#   c(4.206358,	5.293374),
#   c(3.751833,	4.268211),
#   c(6.064487,	7.167248),
#   c(5.854724,	4.510629)
# )
# plot(networkAa, layout=coordsAa)
# # # Figure 3 b) END
#
# //////////////////////////////// .:§:. \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#
# # # Figure 4 a) BEGIN // Network graph for direct links between courses
# library(igraph)
# A<-rbind(c(0,2,0,0,2,0),c(0,1,0,0,0,0),c(2,0,2,1,1,2),c(3,0,1,2,0,1),c(1,0,0,0,0,0))
# rownames(A) <- c("C1:MATH", "C2:PHY", "C3:LOGOP", "C4:ENER", "C5:FIN")
# colnames(A) <- c("K1:manag", "K2:calculus", "K3:control", "K4:energi", "K5:linear", "K6:logistic")
# B=A %*% t(A)
# B[upper.tri(B,diag=TRUE)] <- 0
# networkadj <- graph_from_adjacency_matrix(B, mode="undirected")
# degadj <- igraph::degree(networkadj, mode="all")
# #----
# networkadjw <- graph_from_adjacency_matrix(B, mode="undirected",weighted=TRUE)
# V(networkadjw)$label.cex=1.0
# V(networkadjw)$label.color = adjustcolor("black", 1.0)
# V(networkadjw)$color=adjustcolor("skyblue2", alpha.f = .33)
# V(networkadjw)$size=degadj*4
# V(networkadjw)$frame.color=adjustcolor("SkyBlue2", alpha.f = .0)
# E(networkadjw)$width=E(networkadjw)$weight *3
# E(networkadjw)$color=adjustcolor("gray30", alpha.f = 0.25)
# E(networkadjw)$label=E(networkadjw)$weight
# E(networkadjw)$label.cex = .8
# E(networkadjw)$label.color = adjustcolor("black", 1.0)
# #coordsadj <- layout.fruchterman.reingold(networkadjw)
# coordsadj=rbind(
#    c(2.732845, -0.5228327),
#    c(2.857867,  0.4958321),
#    c(2.580248, -1.7371473),
#    c(2.418976, -2.1789643),
#    c(2.535723, -2.7831462)
#  )
# plot(networkadjw, layout=coordsadj)
# # # Figure 4 a) END
#
# //////////////////////////////// .:§:. \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#
# # # Figure 4 b) BEGIN // Network graph for direct links between tokens
# library(igraph)
# A<-rbind(c(0,2,0,0,2,0),c(0,1,0,0,0,0),c(2,0,2,1,1,2),c(3,0,1,2,0,1),c(1,0,0,0,0,0))
# rownames(A) <- c("C1:MATH", "C2:PHY", "C3:LOGOP", "C4:ENER", "C5:FIN")
# colnames(A) <- c("K1:manag", "K2:calculus", "K3:control", "K4:energi", "K5:linear", "K6:logistic")
# B2=t(A) %*% A
# B2[upper.tri(B2,diag=TRUE)] <- 0
# networkadj2 <- graph_from_adjacency_matrix(B2, mode="undirected")
# degadj2 <- igraph::degree(networkadj2, mode="all")
# #----
# networkadj2w <- graph_from_adjacency_matrix(B2, mode="undirected",weighted=TRUE)
# V(networkadj2w)$label.cex=1.0
# V(networkadj2w)$label.color = adjustcolor("black", 1.0)
# V(networkadj2w)$color=adjustcolor("bisque", alpha.f = .33)
# V(networkadj2w)$size=degadj2*2
# V(networkadj2w)$frame.color=adjustcolor("SkyBlue2", alpha.f = .0)
# E(networkadj2w)$width=E(networkadj2w)$weight *3
# E(networkadj2w)$color=adjustcolor("gray30", alpha.f = 0.25)
# E(networkadj2w)$label=E(networkadj2w)$weight
# E(networkadj2w)$label.cex = .8
# E(networkadj2w)$label.color = adjustcolor("black", 1.0)
# #coordsadj2w <- layout.fruchterman.reingold(networkadj2)
# coordsadj2w=rbind(
#   c(1.540273,	-1.8682586),
#   c(2.947042,	-0.4768527),
#   c(1.443591,	-1.3118913),
#   c(1.132946,	-1.7547813),
#   c(2.235301,	-1.0470740),
#   c(1.869404,	-1.6792466)
# )
# plot(networkadj2w, layout=coordsadj2w)
# # # Figure 4 b) END
