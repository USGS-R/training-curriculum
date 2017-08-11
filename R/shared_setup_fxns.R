# Shared setup functions

setupCourseRmd <- function(slug){
  library(knitr)
  
  knit_hooks$set(plot=function(x, options) {
    sprintf("<img src='../%s%s-%d.%s'/ title='%s'/ alt='%s'/>", 
            options$fig.path, options$label, options$fig.cur, options$fig.ext,
            options$fig.scap, options$fig.cap)
    
  })
  
  opts_chunk$set(
    echo=TRUE,
    fig.path=paste0("static/", slug, "/"),
    fig.width = 6,
    fig.height = 6,
    fig.cap = "TODO",
    fig.scap = "TODO"
  )
  
  set.seed(1)
}
