# Functions to create the argument defintion tables

extract_arg_def <- function(pkg, fn, arg){
  rdbfile <- file.path(find.package(pkg), "help", pkg)
  rdb <- tools:::fetchRdDB(rdbfile, key = fn)
  out <- capture.output(tools::Rd2latex(rdb))
  
  argpattern <- sprintf("\\Q\\item[\\code{%s}] \\E", arg)
  argstart <- which(unlist(lapply(out, grepl, pattern=argpattern)))
  if(length(argstart) == 0){
    stop(sprintf('`%s` is not a valid argument in %s::%s', arg, pkg, fn))
  }
  
  newsection <- which(out == "\\end{ldescription}")
  newlines <- which(out == "")
  newlines_afterarg <- newlines[newlines  > argstart]
  argend <- ifelse(any(newlines_afterarg < newsection), 
                   head(newlines_afterarg, 1),
                   newsection - 1)
  
  argdef <- out[argstart:argend]
  argdef <- paste(argdef, collapse= " ")
  argdef <- gsub(argpattern, "", argdef)
  
  # make URLs usable
  urlpattern <- "(\\\\url)[{](.*?)[}]"
  argdef <- gsub(urlpattern, "\\2", argdef)
  
  # make code show up
  codepattern <- "(\\\\code)[{](.*?)[}]"
  argdef <- gsub(codepattern, "`\\2`", argdef)
  
  tzpattern <- '\",\"'
  argdef <- gsub(tzpattern, '\", \"', argdef)
  
  return(argdef)
}

# requires htmlTable
makeArgDefTable <- function(function.name, table.num){
  
  Argument <- unlist(lapply(function.name, function(f) { names(formals(f)) }))
  pcodes <- which(Argument == "parameterCd")
  statcodes <- which(Argument == "statCd")
  
  Description <- unlist(lapply(function.name, function(fn){
    unlist(lapply(names(formals(fn)), extract_arg_def, 
                  pkg="dataRetrieval", fn=fn))
  }))
  Description[pcodes] <- paste(Description[pcodes], 'See [NWIS help for parameters](https://help.waterdata.usgs.gov/codes-and-parameters/parameters).')
  Description[statcodes] <- paste(Description[statcodes], 'See [NWIS help for statistic codes](https://help.waterdata.usgs.gov/code/stat_cd_nm_query?stat_nm_cd=%25&fmt=html).')
  
  htmlTable(data.frame(Argument, Description), 
            caption=paste0("<caption>Table ", table.num, ". ", function.name, " argument definitions</caption>"),
            rnames=FALSE, align=c("l","l"), col.rgroup = c("none", "#F7F7F7"), 
            css.cell="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em;")
}
