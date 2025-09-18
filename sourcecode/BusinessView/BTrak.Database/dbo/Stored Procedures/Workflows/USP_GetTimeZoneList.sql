CREATE PROCEDURE [dbo].[USP_GetTimeZoneList]  
(  
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
 )  
AS  
BEGIN  
    SELECT TZ.Id AS TimeZoneId,  
    TZ.TimeZoneName,  
     TZ.TimeZoneOffset,  
     TZ.TimeZone,  
     TZ.TimeZoneAbbreviation,  
     TZ.CountryCode,  
     TZ.CountryName,  
                 TZ.CreatedDateTime,  
                 CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,  
                 TZ.[TimeStamp] 
                 
          FROM  [dbo].[TimeZone] TZ WITH (NOLOCK)  
         
END