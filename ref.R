#! Calendar Data
#! 20140613

  calendar <- function() {
    library(RODBC)
    channel2 <- odbcConnect("sqlServer")
    calendar <- sqlQuery(channel2, paste("  
      SELECT calendar_date, fiscal_year, fiscal_period_name,fiscal_period_name_long
        , fiscal_week_of_period,fiscal_week_of_year, fiscal_week_of_period_long, fiscal_week_of_period_name
      FROM FALCON..tlk_calendar
      WHERE calendar_date BETWEEN '1/1/2012' AND '1/1/2016' 
                                         "))
    calendar$date <- as.Date(calendar$calendar_date, format="%m/%d/%Y")
    calendar$yw <- as.numeric(paste(calendar$fiscal_year , calendar$fiscal_week_of_year, sep="")) 
    calendar$fpwk <- paste(calendar$fiscal_period_name,paste("WK",calendar$fiscal_week_of_period,sep=""),sep="")
    return(data.frame(calendar))  
  }
  
  
  fprange <- function() {
    library(RODBC);library(dplyr);
    channel1 <- odbcConnect("sqlServer")
    calendar <- sqlQuery(channel1, "
      SELECT calendar_date as date, fiscal_year, fiscal_period_name
      FROM FALCON..tlk_calendar
      WHERE calendar_date BETWEEN '1/1/2013' AND '1/1/2016' "
    )
    odbcClose(channel1)
    df <- calendar %>%
            group_by(fiscal_year, fiscal_period_name) %>%
            summarise(min=min(date), max=max(date)) 
    return(data.frame(df))
  }

    

