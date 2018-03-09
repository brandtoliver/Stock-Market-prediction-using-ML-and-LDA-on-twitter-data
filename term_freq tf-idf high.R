library(tidy)
library(janeaustenr)
library(tidytext)

x <- tidy(dtm1)

x$document <- as.factor(x$document)
x$count <- as.integer(x$count)


#x <- group_by(x,document, count) %>% mutate(total = sum(count))

x2 <- aggregate(x$count, by=list(document=x$document), FUN=sum)

x3 <- left_join(x, x2)

x3 <- x3 %>%
  bind_tf_idf(term, document, count)

x3 %>%
  select(-x) %>%
  arrange(desc(tf_idf))

plot_tweet <- x3 %>%
  arrange(desc(tf_idf)) %>%
  mutate(term = factor(term, levels = rev(unique(term))))

plot_tweet %>% 
  top_n(40) %>%
  ggplot(aes(term, tf_idf, fill = document)) +
  geom_col() +
  labs(x = NULL, y = "tf-idf") +
  coord_flip()