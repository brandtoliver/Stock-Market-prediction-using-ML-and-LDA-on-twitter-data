library(topicmodels)

burnin <- 40
iter <- 20
thin <- 5
seed <-list(2003,5,63,100001,765) 
nstart <- 5
best <- TRUE

#Gives the number of topics. 
k <- 27

#LDAOut makes a topic model with 10 topics. 
ldaOut <-LDA(dtm1,k, method='Gibbs', control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))

ldaOut.topics <- as.matrix(topics(ldaOut)) 
#write.csv(ldaOut.topics,file=paste('LDAGibbs',k,'DocsToTopics.csv'))
hist(ldaOut.topics)

#Gives top 6 words in each topic:
ldaOut.terms <- as.matrix(terms(ldaOut,6))

#Gives each topic a probability for every document. So
# the topic with the higest probability wihtin each document
# is selected to be the topic of the document. 
topicProbabilities <- as.data.frame(ldaOut@gamma) #Gamma er theta

write.csv(topicProbabilities,paste("LDAGibbs",k=k,"TopicProbabilities.csv"))
