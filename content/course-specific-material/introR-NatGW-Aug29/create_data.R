# devtools::install_github('USGS-R/dataRetrieval') # v2.5.12
library(dataRetrieval)
library(dplyr)

# find wells in Nevada with at least 10 years of groundwater level data
sites <- whatNWISsites(stateCd="NV", siteType='GW')
group_size <- 250
gwqueries <- lapply(1:ceiling(nrow(sites)/group_size), function(site_group) {
  group_indices <- ((site_group-1)*group_size+1):min(nrow(sites), site_group*group_size)
  message(paste0('querying sites ', head(group_indices, 1), ' to ', tail(group_indices, 1)))
  tryCatch(whatNWISdata(sites$site_no[group_indices], service='gw'), error=function(e) NULL)
})
gwinventory <- gwqueries %>%
  lapply(function(g) { 
    # fix bind_rows incompatibility among the gwqueries dfs
    mutate(g, alt_acy_va = as.character(alt_acy_va))
  } ) %>% 
  bind_rows()
# find the five wells that have >= 500 observations of pcode 72019 and were sampled in the past year
gwsites <- filter(gwinventory, parm_cd == '72019', count_nu >= 500, end_date >= as.Date('2015-09-01'))

# download the data
gwlevelsraw <- readNWISgwl(siteNumbers = gwsites$site_no)

# simplify the data
PST <- "Etc/GMT+8"
gwlevels <- gwlevelsraw %>% 
  mutate(date_time = as.POSIXct(
    ifelse(is.na(lev_dateTime), as.POSIXct(paste0(lev_dt, '12:00:00'), tz=PST), lev_dateTime),
    origin='1970-01-01', tz=PST)) %>%
  select(site_no, date_time, level_ft=lev_va)

# extract the metadata
gwsiteinfo <- attr(gwlevelsraw, 'siteInfo') %>%
  select(site_no, station_nm, dec_lat_va, dec_long_va, coord_datum_cd, alt_va, alt_datum_cd, huc_cd)
paraminfo <- parameterCdFile %>% filter(parameter_group_nm == 'Physical', parameter_units %in% c('ft', 'm'))

# write to files
write.csv(gwlevels, file = 'gwlevels.csv', row.names=FALSE)
write.csv(gwsiteinfo, file = 'gwsiteinfo.csv', row.names=FALSE)
write.csv(paraminfo, file = 'paraminfo.csv', row.names=FALSE)

library(XLConnect)
workbook <- loadWorkbook('gwlevels.xlsx', create = TRUE)
createSheet(workbook, 'gwlevels')
writeWorksheet(workbook, gwlevels, sheet = "gwlevels")
createSheet(workbook, 'gwsiteinfo')
writeWorksheet(workbook, gwsiteinfo, sheet = "gwsiteinfo", startRow = 3, startCol = 2)
createSheet(workbook, 'paraminfo')
writeWorksheet(workbook, paraminfo, sheet = "paraminfo")
saveWorkbook(workbook, file = workbook@filename)
