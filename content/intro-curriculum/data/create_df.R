
# create data frame to use throughout entire course

getNWISdf <- function(stateCd, startDate, endDate){
  dischargeCd <- '00060'
  tempCd <- '00010'
  pHCd <- '00400'
  doCd <- '00300'
  pcodes <- c(dischargeCd, tempCd, pHCd, doCd)
  
  nwis_sites_parm1 <- whatNWISsites(stateCd=stateCd, siteType="ST", parameterCd = pcodes[1], startDT = startDate)
  
  sites_w_parms <- whatNWISdata(nwis_sites_parm1$site_no) %>% 
    select(site_no, parm_cd, begin_date, end_date) %>% 
    filter(begin_date <= as.Date(startDate), end_date >= as.Date(endDate), parm_cd %in% pcodes) %>% 
    na.omit() %>% 
    group_by(site_no) %>% 
    filter(all(pcodes %in% parm_cd)) %>% 
    ungroup() 
  sites <- unique(sites_w_parms$site_no)
  
  nwis_data <- readNWISdata(siteNumbers=sites, parameterCd=pcodes,
                            startDate=startDate, endDate=endDate, service="iv") %>% 
    renameNWISColumns() %>% 
    select(site_no, dateTime, Flow_Inst, Flow_Inst_cd, Wtemp_Inst, pH_Inst, DO_Inst) %>% 
    na.omit()
  
  return(nwis_data)
}

createTrainingDF <- function(nwis_data, filename = "vignettes/data/course_NWISdata.csv"){
  # Altering NWIS data for training example
  nwis_data_changed <- nwis_data %>% 
    sample_n(3000, replace=nrow(nwis_data) < 3000) %>% 
    mutate(Flow_Inst = insertRandomNAs(Flow_Inst),
           Wtemp_Inst = insertRandomNAs(Wtemp_Inst),
           pH_Inst = insertRandomNAs(pH_Inst),
           DO_Inst = insertRandomNAs(DO_Inst)) %>% 
    mutate(Flow_Inst_cd = insertRandomValues(Flow_Inst_cd, percentChange = 0.5, 
                                             values = c("A e", "E", "X")),
           pH_Inst = insertRandomValues(pH_Inst, percentChange = 0.01, 
                                        values = c("NA", "None", " ")))
  
  write.csv(nwis_data_changed, filename, row.names=FALSE)
  
  return(nwis_data_changed)
}

# Functions to manipulate a data.frame

insertRandomNAs <- function(orig_col, nrows = 3000, percentNA = 0.03){
  new_col <- orig_col
  nNAs <- round(nrows*percentNA)
  NA_rows <- sample(1:nrows, size=nNAs)
  new_col[NA_rows] <- NA
  return(new_col)
}

insertRandomValues <- function(orig_col, nrows = 3000, percentChange, values){
  new_col <- orig_col
  nChange <- round(nrows*percentChange) 
  change_rows <- sample(1:nrows, size=nChange)
  new_col[change_rows] <- values
  return(new_col)
}

createDFCleanSubset <- function(intro_df, filename = "vignettes/data/course_NWISdata_cleaned.csv"){
  # data frame after subsetting section in Clean
  cleaned_df <- mutate(intro_df, pH_Inst = as.numeric(pH_Inst))
  write.csv(cleaned_df, filename, row.names=FALSE)
  return(cleaned_df)
}

# Workflow to create training df

library(dataRetrieval)
library(dplyr)

stateCd <- "GA"
startDate <- "2011-05-01"
endDate <- "2011-05-31"

nwis_data <- getNWISdf(stateCd, startDate, endDate)
intro_df <- createTrainingDF(nwis_data)
clean_df <- createDFCleanSubset(intro_df)
