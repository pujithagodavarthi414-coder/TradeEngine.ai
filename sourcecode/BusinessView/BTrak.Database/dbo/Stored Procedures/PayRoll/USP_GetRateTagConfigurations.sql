CREATE PROCEDURE [dbo].[USP_GetRateTagConfigurations]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@RateTagRoleBranchConfigurationId UNIQUEIDENTIFIER = NULL,
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL,
	@IsArchived BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250) = '1'

		IF (@HavePermission = '1')
		BEGIN
		
		   DECLARE @CurrentDate DATE = CAST(GETDATE() AS DATE)

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
		   SELECT RTC.Id AS RateTagConfigurationId,
				  RT.Id RateTagId,
				  RT.CompanyId,
				  RT.RateTagName,
				  C.Id [RateTagCurrencyId],
				  C.CurrencyName [RateTagCurrencyName],
				  C.CurrencyCode [RateTagCurrencyCode],
				  RTC.RatePerHour,
				  RTC.RatePerHourMon,
				  RTC.RatePerHourTue,
				  RTC.RatePerHourWed,
				  RTC.RatePerHourThu,
				  RTC.RatePerHourFri,
				  RTC.RatePerHourSat,
				  RTC.RatePerHourSun,
				  RTC.CreatedDateTime,
				  RTC.CreatedByUserId,
				  RTC.[TimeStamp],
				  RTC.[Priority],
				  (SELECT RTD.RateTagForId,RTD.RateTagForType,
			  	  CASE WHEN RTF.RateTagForName IS NOT NULL THEN RTF.RateTagForName
				                                             WHEN PD.PartsOfDayName IS NOT NULL THEN PD.PartsOfDayName
				                                             WHEN WD.WeekDayName IS NOT NULL THEN WD.WeekDayName
															 WHEN H.Reason IS NOT NULL THEN H.Reason 
				                                             WHEN SD.Reason IS NOT NULL THEN SD.Reason ELSE '' END AS RateTagForName
				                   FROM RateTagDetails RTD
						           LEFT JOIN RateTagFor RTF ON RTD.RateTagForId = RTF.Id
								   LEFT JOIN PartsOfDay PD ON RTD.RateTagForId = PD.Id
								   LEFT JOIN WeekDays WD ON RTD.RateTagForId = WD.Id
								   LEFT JOIN Holiday H ON RTD.RateTagForId = H.Id
								   LEFT JOIN SpecificDay SD ON RTD.RateTagForId = SD.Id
						           WHERE RTD.RateTagId = RT.Id
	                               FOR JSON AUTO) as RateTagDetails,
				   RateTagForNames = STUFF((SELECT ',' + CASE WHEN RTF.RateTagForName IS NOT NULL THEN RTF.RateTagForName
				                                             WHEN PD.PartsOfDayName IS NOT NULL THEN PD.PartsOfDayName
				                                             WHEN WD.WeekDayName IS NOT NULL THEN WD.WeekDayName
															 WHEN H.Reason IS NOT NULL THEN H.Reason 
				                                             WHEN SD.Reason IS NOT NULL THEN SD.Reason ELSE '' END
					             FROM RateTagDetails RTD
						         LEFT JOIN RateTagFor RTF ON RTD.RateTagForId = RTF.Id
								 LEFT JOIN PartsOfDay PD ON RTD.RateTagForId = PD.Id
								 LEFT JOIN WeekDays WD ON RTD.RateTagForId = WD.Id
								 LEFT JOIN Holiday H ON RTD.RateTagForId = H.Id
								 LEFT JOIN SpecificDay SD ON RTD.RateTagForId = SD.Id
						         WHERE RTD.RateTagId = RT.Id
						         ORDER BY RTF.RateTagForName
					             FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''),
				  CASE WHEN RTC.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM [dbo].[RateTagConfiguration] AS RTC 
		   JOIN RateTagRoleBranchConfiguration AS RTRBC on RTRBC.Id = RTC.RateTagRoleBranchConfigurationId
		   LEFT JOIN RateTag AS RT on RTC.RateTagId = RT.Id AND RT.InActiveDateTime IS NULL
		   LEFT JOIN SYS_Currency C ON C.Id = RTC.RateTagCurrencyId 
           WHERE (RT.CompanyId = @CompanyId)
		        AND (@IsArchived IS NULL 
			        OR (@IsArchived = 1 AND RTRBC.InActiveDateTime IS NOT NULL) 
					OR (@IsArchived = 0 AND RTRBC.InActiveDateTime IS NULL))
				AND (@RateTagRoleBranchConfigurationId IS NULL OR RateTagRoleBranchConfigurationId = @RateTagRoleBranchConfigurationId)
				AND RTC.InActiveDateTime IS NULL
				AND (@StartDate IS NULL OR @EndDate IS NULL OR CONVERT(DATE ,RTRBC.StartDate) = CONVERT(DATE ,@StartDate) AND CONVERT(DATE ,RTRBC.EndDate) = CONVERT(DATE ,@EndDate))
		END
		ELSE
		BEGIN
			RAISERROR (@HavePermission,11, 1)
		END

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END
