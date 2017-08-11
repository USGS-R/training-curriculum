# Shared setup functions

setupCourseRmd <- function(slug = rmarkdown::metadata[['slug']]){
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
  
  knit_hooks$set(addToggle = function(before, options, envir) {
    if(before) {
      sprintf('<button class="ToggleButton" onclick="toggle_visibility(\'%1$s\')">Show Answer</button>
              <div id="%1$s" style="display:none">', opts_current$get('label'))
    } else {
      '</div>'
    }
  })
  
  set.seed(1)
}
