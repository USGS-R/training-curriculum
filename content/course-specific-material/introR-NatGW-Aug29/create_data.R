# devtools::install_github('USGS-R/dataRetrieval') # v2.5.12
library(dataRetrieval)
library(dplyr)

# find wells in Nevada with at least 10 years of groundwater level data
sites <- readNWISdata(stateCd="NV", siteType='GW', service = "site", seriesCatalogOutput=TRUE)

gwqueries <- sites %>%
  filter(parm_cd == '72019',
         count_nu >= 500, 
         end_date >= as.POSIXct('2015-09-01'))

# download the data
gwlevelsraw <- readNWISgwl(siteNumbers = gwqueries$site_no)

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
paraminfo <- readNWISpCode('72019')

# write to files
write.csv(gwlevels, file = 'gwlevels.csv', row.names=FALSE)
write.csv(gwsiteinfo, file = 'gwsiteinfo.csv', row.names=FALSE)
write.csv(paraminfo, file = 'paraminfo.csv', row.names=FALSE)

