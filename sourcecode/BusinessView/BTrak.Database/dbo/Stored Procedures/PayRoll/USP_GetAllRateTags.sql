--EXEC [USP_GetAllRateTags] @OperationsPerformedBy = ''
CREATE PROCEDURE [dbo].[USP_GetAllRateTags]
	@RateTagId UNIQUEIDENTIFIER = NULL,
	@RateTagName NVARCHAR(800) = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL,
	@RoleId UNIQUEIDENTIFIER = NULL,
	@BranchId UNIQUEIDENTIFIER = NULL,
	@EmployeeId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
		
		   IF(@RateTagId = '00000000-0000-0000-0000-000000000000') SET @RateTagId = NULL

		   IF(@RateTagName = '') SET @RateTagName = NULL

		   IF(@SearchText = '') SET @SearchText = NULL

		   DECLARE @CurrentDate DATE = CAST(GETDATE() AS DATE)

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   
		   --DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = @OperationsPerformedBy)

		   --DECLARE @BranchId UNIQUEIDENTIFIER = (SELECT BranchId FROM EmployeeBranch EB WHERE EB.EmployeeId = @EmployeeId
					--									  AND ( (EB.ActiveTo IS NOT NULL AND @CurrentDate BETWEEN EB.ActiveFrom AND EB.ActiveTo)
					--									          OR (EB.ActiveTo IS NULL AND @CurrentDate >= EB.ActiveFrom)
					--											  OR (EB.ActiveTo IS NOT NULL AND @CurrentDate <= EB.ActiveTo)
					--										  ) )

		   --DECLARE @RoleIds NVARCHAR(MAX) = (SELECT STUFF((SELECT ',' + CAST(RoleId AS NVARCHAR(100)) FROM UserRole WHERE UserId = @OperationsPerformedBy FOR XML PATH ('')) , 1, 1, ''))

		   SELECT * FROM (

           SELECT RT.Id AS RateTagId,
				  RT.CompanyId,
				  RT.RateTagName,
				  RT.RatePerHour,
				  RT.RatePerHourMon,
				  RT.RatePerHourTue,
				  RT.RatePerHourWed,
				  RT.RatePerHourThu,
				  RT.RatePerHourFri,
				  RT.RatePerHourSat,
				  RT.RatePerHourSun,
				  RT.CreatedDateTime,
				  RT.CreatedByUserId,
				  RT.[TimeStamp],
				  NULL AS [Priority],
				  [MaxTime],
				  [MinTime],
				  CASE WHEN RT.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER(),
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
					             FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') 
           FROM [dbo].[RateTag] AS RT 
           WHERE RT.CompanyId = @CompanyId
		   	   AND (@RateTagId IS NULL OR RT.Id = @RateTagId)
		   	   AND (@RateTagName IS NULL OR RT.RateTagName = @RateTagName)
			   AND (@IsArchived IS NULL 
			        OR (@IsArchived = 1 AND RT.InActiveDateTime IS NOT NULL) 
					OR (@IsArchived = 0 AND RT.InActiveDateTime IS NULL))
			   AND RT.EmployeeId IS NULL AND RT.RoleId IS NULL AND RT.BranchId IS NULL

		  UNION

		  SELECT RT.Id AS RateTagId,
				  RT.CompanyId,
				  RT.RateTagName,
				  RT.RatePerHour,
				  RT.RatePerHourMon,
				  RT.RatePerHourTue,
				  RT.RatePerHourWed,
				  RT.RatePerHourThu,
				  RT.RatePerHourFri,
				  RT.RatePerHourSat,
				  RT.RatePerHourSun,
				  RT.CreatedDateTime,
				  RT.CreatedByUserId,
				  RT.[TimeStamp],
				  NULL AS [Priority],
				  [MaxTime],
				  [MinTime],
				  CASE WHEN RT.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER(),
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
					             FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') 
           FROM [dbo].[RateTag] AS RT 
           WHERE RT.CompanyId = @CompanyId
		   	   AND (@RateTagId IS NULL OR RT.Id = @RateTagId)
		   	   AND (@RateTagName IS NULL OR RT.RateTagName = @RateTagName)
			   AND (@IsArchived IS NULL 
			        OR (@IsArchived = 1 AND RT.InActiveDateTime IS NOT NULL) 
					OR (@IsArchived = 0 AND RT.InActiveDateTime IS NULL))
			   AND RT.EmployeeId = @EmployeeId

		  UNION

		  SELECT RT.Id AS RateTagId,
				  RT.CompanyId,
				  RT.RateTagName,
				  RT.RatePerHour,
				  RT.RatePerHourMon,
				  RT.RatePerHourTue,
				  RT.RatePerHourWed,
				  RT.RatePerHourThu,
				  RT.RatePerHourFri,
				  RT.RatePerHourSat,
				  RT.RatePerHourSun,
				  RT.CreatedDateTime,
				  RT.CreatedByUserId,
				  RT.[TimeStamp],
				  NULL AS [Priority],
				  [MaxTime],
				  [MinTime],
				  CASE WHEN RT.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER(),
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
					             FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') 
           FROM [dbo].[RateTag] AS RT 
           WHERE RT.CompanyId = @CompanyId
		   	   AND (@RateTagId IS NULL OR RT.Id = @RateTagId)
		   	   AND (@RateTagName IS NULL OR RT.RateTagName = @RateTagName)
			   AND (@IsArchived IS NULL 
			        OR (@IsArchived = 1 AND RT.InActiveDateTime IS NOT NULL) 
					OR (@IsArchived = 0 AND RT.InActiveDateTime IS NULL))
			   AND ((RT.RoleId IS NULL AND RT.BranchId = @BranchId)
			        OR (RT.BranchId IS NULL AND RT.RoleId = @RoleId)
					OR (RT.RoleId = @RoleId AND RT.BranchId = @BranchId))

		) T

		ORDER BY RateTagName

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