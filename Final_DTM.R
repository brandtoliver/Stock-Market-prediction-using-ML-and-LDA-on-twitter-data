datasub3 <- read.csv("/zhome/ed/f/98454/FINAL_TweetDat.csv")


datasub3$X <- NULL
####################################################
library(tm)


dataCorpus <- Corpus(VectorSource(datasub3$Body))
dataCorpus = tm_map(dataCorpus, tolower);
dataCorpus = tm_map(dataCorpus, removePunctuation);
dataCorpus = tm_map(dataCorpus, removeNumbers);

stop <- as.character(read.csv('/zhome/ed/f/98454/Stopwords_listCorrect.csv',header = FALSE, sep = " ")$V1)
####bruger "stem" og andre funktioner til at tilpasse dataen
myStopwords = c(stopwords('english'), "available", "via",stop,"reifer");
myStopwords <- myStopwords[c(-133,-134,-137,-138,-139,-140,-143,-144,-418,-707,-725,-179,-549)]


dataCorpus = tm_map(dataCorpus, removeWords, myStopwords);

#dictCorpus = dataCorpus;

dataCorpus = tm_map(dataCorpus, stemDocument);

#dataCorpus = tm_map(dataCorpus, stemCompletion, dictionary=dictCorpus);

myDtm = DocumentTermMatrix(dataCorpus, control = list(minWordLength = 2));


dtm1<-removeSparseTerms(myDtm,0.002)


dim(dtm1)
dim(dtm2)

######tilf??jelse###
#convert rownames to filenames

#rownames(dtm) <- filenames
#collapse matrix by summing over columns
freq <- colSums(as.matrix(dtm1))
#length should be total number of terms
length(freq)
#create sort order (descending)
ord <- order(freq,decreasing=TRUE)
#List all terms in decreasing order of freq and write to disk
a_1<-as.data.frame(freq[ord])
write.csv(freq[ord],"Tjek699.csv")

###########F??rste gennemtjek 





#########Tilføjer flere stopwords
stop_1 <- as.character(read.csv('/zhome/ed/f/98454/Stopwords_10jun.csv',header = FALSE, sep = " ")$V1)


myStopwords = c(stopwords('english'), "available", "via",stop,stop_1,"reifer","posit","estim","dilut","appl");
myStopwords <- myStopwords[c(-133,-134,-137,-138,-139,-140,-143,-144,-418,-707,-725,-179,-549)]


dataCorpus = tm_map(dataCorpus, removeWords, myStopwords);



myDtm = DocumentTermMatrix(dataCorpus, control = list(minWordLength = 2));  #Evt sæt: , weighting= TFweighting

dtm1<-removeSparseTerms(myDtm,0.002)

dim(dtm1)

write.csv(as.matrix(dtm1),'DTM_10jun.csv')


8######tilf??jelse###
#convert rownames to filenames

#rownames(dtm) <- filenames
#collapse matrix by summing over columns
freq <- colSums(as.matrix(dtm1))
#length should be total number of terms
length(freq)
#create sort order (descending)
ord <- order(freq,decreasing=TRUE)
#List all terms in decreasing order of freq and write to disk
a_1<-as.data.frame(freq[ord])
#write.csv(freq[ord],"freq_3.csv")



dtm1 <- read.csv('/zhome/ed/f/98454/DTM_Final.csv',header = TRUE, sep = ",")
dtm1 <- dtm1[2:261]

#Make a LDA:
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
