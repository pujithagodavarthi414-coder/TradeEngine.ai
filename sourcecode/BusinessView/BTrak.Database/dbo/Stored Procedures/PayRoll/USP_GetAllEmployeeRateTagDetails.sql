CREATE PROCEDURE [dbo].[USP_GetAllEmployeeRateTagDetails]
(
	@EmployeeId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL,
	@RateTagRoleBranchConfigurationId  UNIQUEIDENTIFIER = NULL,
	@GroupPriority INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = '1'

		IF (@HavePermission = '1')
		BEGIN
		
			DECLARE @CurrentDate DATE = CAST(GETDATE() AS DATE)

		   IF(@SearchText = '') SET @SearchText = NULL
		   DECLARE @SortDirection VARCHAR(50)

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   DECLARE @IsPermanent BIT = (SELECT ES.ISPermanent FROM Job J 
		                                         JOIN EmploymentStatus ES ON ES.Id = J.EmploymentStatusId AND ES.InActiveDateTime IS NULL
												 WHERE J.EmployeeId = @EmployeeId
												 AND ES.CompanyId = @CompanyId
												 AND J.InActiveDateTime IS NULL)
       	   
		   SELECT * FROM (
           SELECT RTC.Id AS EmployeeRateTagId,
				  RT.ID RateTagId,
				  RT.RateTagName,
				  C.Id [RateTagCurrencyId],
				  C.CurrencyName [RateTagCurrencyName],
				  C.CurrencyCode [RateTagCurrencyCode],
				  RTC.RateTagStartDate,
				  RTC.RateTagEndDate,
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
				  RTC.RateTagEmployeeId,
				  RTC.[Priority],
				  RTC.[GroupPriority],
				  CONVERT(varchar, RTC.RateTagStartDate, 106)  + ' to ' + CONVERT(varchar, RTC.RateTagEndDate, 106) AS DatePeriod, 
				  0 AS IsInHerited,
				  RTC.IsOverRided,
				  NULL AS RoleBranchConfigurationId,
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
				  CASE WHEN RTC.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
           FROM [dbo].[EmployeeRateTag] AS RTC 
		   INNER JOIN Employee E ON E.Id = RTC.RateTagEmployeeId
		   INNER JOIN [USER] U ON U.Id = E.UserId and U.InActiveDateTime IS NULL AND U.IsActive = 1
		   INNER JOIN RateTag AS RT on RTC.RateTagId = RT.Id AND RT.InActiveDateTime IS NULL
		   LEFT JOIN SYS_Currency C ON C.Id = RTC.RateTagCurrencyId 
           WHERE RT.CompanyId = @CompanyId AND CONVERT(DATE, RTC.RateTagEndDate) >= CONVERT(DATE, GETDATE())
				AND (@EmployeeId IS NULL OR RTC.RateTagEmployeeId = @EmployeeId)				
				AND RTC.InActiveDateTime IS NULL
				AND (CONVERT(DATE, RTC.RateTagStartDate) = CONVERT(DATE, @StartDate))
				AND (CONVERT(DATE, RTC.RateTagEndDate) = CONVERT(DATE, @EndDate))
				AND ((@GroupPriority IS NULL AND RTC.GroupPriority IS NULL ) OR RTC.GroupPriority = @GroupPriority)

			UNION

			SELECT RTC.Id AS EmployeeRateTagId,
				  RT.ID RateTagId,
				  RT.RateTagName,
				  C.Id [RateTagCurrencyId],
				  C.CurrencyName [RateTagCurrencyName],
				  C.CurrencyCode [RateTagCurrencyCode],
				  RTRBC.StartDate,
				  RTRBC.EndDate,
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
				  E.Id RateTagEmployeeId,
				  RTC.[Priority],
				  NULL [GroupPriority],
				  CONVERT(varchar, RTRBC.StartDate, 106)  + ' to ' + CONVERT(varchar, RTRBC.EndDate, 106) AS DatePeriod, 
				  1 AS IsInHerited,
				  0 AS IsOverRided,
				  RTC.RateTagRoleBranchConfigurationId AS RoleBranchConfigurationId,
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
				  CASE WHEN RTC.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
           FROM [dbo].RateTagConfiguration AS RTC 
		   INNER JOIN RateTagRoleBranchConfiguration AS RTRBC on RTRBC.Id = RTC.RateTagRoleBranchConfigurationId AND RTRBC.InActiveDateTime IS NULL
		   INNER JOIN RateTag AS RT on RTC.RateTagId = RT.Id AND RT.InActiveDateTime IS NULL
		   INNER JOIN EmployeeBranch EB ON EB.BranchId = RTRBC.BranchId
		              AND ((ActiveTo IS NOT NULL AND @CurrentDate BETWEEN ActiveFrom AND ActiveTo)
	  						OR (ActiveTo IS NULL AND @CurrentDate >= CONVERT(DATE, ActiveFrom))
							OR (ActiveTo IS NOT NULL AND @CurrentDate <= CONVERT(DATE, ActiveTo))
	  			          )
		   INNER JOIN Employee E ON E.Id = EB.EmployeeId
		   INNER JOIN [USER] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
		   LEFT JOIN SYS_Currency C ON C.Id = RTC.RateTagCurrencyId 
           WHERE RT.CompanyId = @CompanyId 
		        AND @IsPermanent = 0
		        AND CONVERT(DATE, RTRBC.EndDate) >= CONVERT(DATE, GETDATE()) AND RTRBC.BranchId IS NOT NULL AND RTRBC.RoleId IS NULL
				AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)				
				AND RTC.InActiveDateTime IS NULL
		        AND (RTRBC.Id = @RateTagRoleBranchConfigurationId)

		   UNION

			SELECT RTC.Id AS EmployeeRateTagId,
				  RT.ID RateTagId,
				  RT.RateTagName,
				  C.Id [RateTagCurrencyId],
				  C.CurrencyName [RateTagCurrencyName],
				  C.CurrencyCode [RateTagCurrencyCode],
				  RTRBC.StartDate,
				  RTRBC.EndDate,
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
				  E.Id RateTagEmployeeId,
				  RTC.[Priority],
				  NULL [GroupPriority],
				  CONVERT(varchar, RTRBC.StartDate, 106)  + ' to ' + CONVERT(varchar, RTRBC.EndDate, 106) AS DatePeriod, 
				  1 AS IsInHerited,
				  0 AS IsOverRided,
				  RTC.RateTagRoleBranchConfigurationId AS RoleBranchConfigurationId,
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
				  CASE WHEN RTC.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
           FROM [dbo].RateTagRoleBranchConfiguration AS RTRBC 
		   INNER JOIN RateTagConfiguration AS RTC on RTC.RateTagRoleBranchConfigurationId = RTRBC.Id AND RTRBC.InActiveDateTime IS NULL
		   INNER JOIN RateTag AS RT on RTC.RateTagId = RT.Id AND RT.InActiveDateTime IS NULL
		   INNER JOIN UserRole UR ON UR.RoleId = RTRBC.RoleId AND UR.InActiveDateTime IS NULL 
		   INNER JOIN [USER] U ON U.Id = UR.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
		   INNER JOIN Employee E ON E.UserId = U.Id
		   LEFT JOIN SYS_Currency C ON C.Id = RTC.RateTagCurrencyId 
           WHERE RT.CompanyId = @CompanyId AND @IsPermanent = 0 
		        AND CONVERT(DATE, RTRBC.EndDate) >= CONVERT(DATE, GETDATE()) AND RTRBC.RoleId IS NOT NULL AND RTRBC.BranchId IS NULL
				AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)				
				AND RTC.InActiveDateTime IS NULL
				AND (RTRBC.Id = @RateTagRoleBranchConfigurationId)

			UNION

			SELECT RTC.Id AS EmployeeRateTagId,
				  RT.ID RateTagId,
				  RT.RateTagName,
				  C.Id [RateTagCurrencyId],
				  C.CurrencyName [RateTagCurrencyName],
				  C.CurrencyCode [RateTagCurrencyCode],
				  RTRBC.StartDate,
				  RTRBC.EndDate,
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
				  E.Id RateTagEmployeeId,
				  RTC.[Priority],
				  NULL [GroupPriority],
				  CONVERT(varchar, RTRBC.StartDate, 106)  + ' to ' + CONVERT(varchar, RTRBC.EndDate, 106) AS DatePeriod, 
				  1 AS IsInHerited,
				  0 AS IsOverRided,
				  RTC.RateTagRoleBranchConfigurationId AS RoleBranchConfigurationId,
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
				  CASE WHEN RTC.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
           FROM [dbo].RateTagRoleBranchConfiguration AS RTRBC 
		   INNER JOIN RateTagConfiguration AS RTC on RTC.RateTagRoleBranchConfigurationId = RTRBC.Id AND RTRBC.InActiveDateTime IS NULL
		   INNER JOIN RateTag AS RT on RTC.RateTagId = RT.Id AND RT.InActiveDateTime IS NULL
		   INNER JOIN EmployeeBranch EB ON EB.BranchId = RTRBC.BranchId
		                   AND ((ActiveTo IS NOT NULL AND @CurrentDate BETWEEN ActiveFrom AND ActiveTo)
	  						OR (ActiveTo IS NULL AND @CurrentDate >= CONVERT(DATE, ActiveFrom))
							OR (ActiveTo IS NOT NULL AND @CurrentDate <= CONVERT(DATE, ActiveTo))
	  			          )
		   INNER JOIN Employee E ON E.Id = EB.EmployeeId
		   INNER JOIN [USER] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
		   INNER JOIN UserRole UR ON UR.RoleId = RTRBC.RoleId AND UR.UserId = U.Id  AND UR.InActiveDateTime IS NULL 
		   LEFT JOIN SYS_Currency C ON C.Id = RTC.RateTagCurrencyId 
           WHERE RT.CompanyId = @CompanyId AND @IsPermanent = 0 
		        AND CONVERT(DATE, RTRBC.EndDate) >= CONVERT(DATE, GETDATE()) AND RTRBC.BranchId IS NOT NULL AND RTRBC.RoleId IS NOT NULL
				AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)				
				AND RTC.InActiveDateTime IS NULL
				AND (RTRBC.Id = @RateTagRoleBranchConfigurationId)

			  UNION 	 
				
			  SELECT RTC.Id AS EmployeeRateTagId,
				  RT.ID RateTagId,
				  RT.RateTagName,
				  C.Id [RateTagCurrencyId],
				  C.CurrencyName [RateTagCurrencyName],
				  C.CurrencyCode [RateTagCurrencyCode],
				  RTRBC.StartDate,
				  RTRBC.EndDate,
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
				  NULL RateTagEmployeeId,
				  RTC.[Priority],
				  NULL [GroupPriority],
				  CONVERT(varchar, RTRBC.StartDate, 106)  + ' to ' + CONVERT(varchar, RTRBC.EndDate, 106) AS DatePeriod, 
				  1 AS IsInHerited,
				  0 AS IsOverRided,
				  RTC.RateTagRoleBranchConfigurationId AS RoleBranchConfigurationId,
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
				  CASE WHEN RTC.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
           FROM [dbo].RateTagRoleBranchConfiguration AS RTRBC 
		   INNER JOIN RateTagConfiguration AS RTC on RTC.RateTagRoleBranchConfigurationId = RTRBC.Id AND RTRBC.InActiveDateTime IS NULL
		   INNER JOIN RateTag AS RT on RTC.RateTagId = RT.Id AND RT.InActiveDateTime IS NULL
		   LEFT JOIN SYS_Currency C ON C.Id = RTC.RateTagCurrencyId 
           WHERE RT.CompanyId = @CompanyId AND @IsPermanent = 0 
		        AND CONVERT(DATE, RTRBC.EndDate) >= CONVERT(DATE, GETDATE()) AND RTRBC.BranchId IS NULL AND RTRBC.RoleId IS NULL
				AND RTC.InActiveDateTime IS NULL
				AND (RTRBC.Id = @RateTagRoleBranchConfigurationId)
			) T
			ORDER BY RateTagEmployeeId,CreatedDateTime,RateTagStartDate,RateTagEndDate		

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