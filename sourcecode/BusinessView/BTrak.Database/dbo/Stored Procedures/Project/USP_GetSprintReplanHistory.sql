CREATE PROCEDURE [dbo].[USP_GetSprintReplanHistory]
(
 @SprintId UNIQUEIDENTIFIER,
 @SprintReplanCount INT = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER
)
As
BEGIN 
	SET NOCOUNT ON 
	BEGIN 	TRY
				
		DECLARE @HavePermission NVARCHAR(250) = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy, (SELECT OBJECT_NAME(@@PROCID))))
				
		IF (@HavePermission='1')
		BEGIN 
						
			DECLARE @CompanyId UNIQUEIDENTIFIER=(SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @MaxReplanCount INT = (SELECT COUNT(1)FROM GoalReplan WHERE GoalId = @SprintId)

			IF (@SprintReplanCount IS NULL) SET @SprintReplanCount = @MaxReplanCount

			DECLARE @ApprovedUserId UNIQUEIDENTIFIER,@SprintCreatedDateTime DATETIMEOFFSET 
			
			SELECT TOP 1 @ApprovedUserId = CreatedByUserId,
			             @SprintCreatedDateTime = CreatedDateTime 
			             FROM Sprints 
						 WHERE UpdatedDateTime > (SELECT CreatedDateTime
											             FROM GoalReplan 
														 WHERE GoalId = @SprintId 
														   AND GoalReplanCount = @SprintReplanCount ) 
						ORDER BY CreatedDateTime

			DECLARE @ApprovedUser NVARCHAR(100) =  (SELECT Firstname + ' ' + ISNULL(Surname,'') 
			                                               FROM [User] WHERE Id = @ApprovedUserId)
            DECLARE @SprintDelay INT = (SELECT DATEDIFF(DAY,MAX(ActualSprintEndDate),MAX(SprintEndDate)) FROM Sprints WHERE Id = @SprintId AND CreatedDateTime <= @SprintCreatedDateTime GROUP BY Id)

            SELECT GR.CreatedDateTime  AS DateOfReplan,
			       TZ.TimeZoneName,
				   TZ.TimeZoneAbbreviation,
			       GR.Id AS SprintReplanId,
                   S.Id As SprintId,
			       S.SprintName,
			       USRH.GoalReplanCount AS SprintReplanCount,
				   @MaxReplanCount AS MaxReplanCount,
				   @ApprovedUserId AS ApprovedUserId,
				   @ApprovedUser AS ApprovedUser,
                   GRT.GoalReplanTypeName AS SprintReplanName,
			       US.Id AS UserStoryId,
			       US.UserStoryName,
			       US.UserStoryUniqueName,
			       GR.CreatedByUserId,
			       U.FirstName + ' ' + ISNULL(U.SurName,'') AS RequestedBy,
                   USRH.NewValue,
			       USRH.OldValue,
				   USRT.ReplanTypeName AS UserStoryReplanName,
				   CASE WHEN USRT.IsDeadLineChange = 1 THEN ISNULL(DATEDIFF(DAY,US.ActualDeadLineDate,CONVERT(DATE,USRH.[NewValue])),0) 
				               ELSE ISNULL(DATEDIFF(DAY,CONVERT(DATE,US.ActualDeadLineDate),US.DeadLineDate),0) END AS [UserStoryDelay],
				   USRH.UserStoryReplanJson AS [Description],
				   ISNULL(@SprintDelay,0) AS SprintDelay,
				   SprintMembers = (STUFF((SELECT ','+CAST(UR.FirstName+' '+ISNULL(UR.SurName,'') AS VARCHAR)
				                         FROM UserStory US 
									     JOIN Sprints S ON US.SprintId = S.Id
										  AND US.InactiveDateTime IS NULL
										  AND US.ParkedDateTime IS NULL 
										  AND S.Id = @SprintId 
										 JOIN [User] UR ON UR.Id = US.OwnerUserId AND UR.IsActive = 1
										 GROUP BY CAST(UR.FirstName+' '+ISNULL(UR.SurName,'') AS VARCHAR)
									     FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
                   FROM GoalReplan GR
                   JOIN Sprints S ON S.Id = GR.GoalId AND S.InActiveDateTime IS NULL AND S.Id = @SprintId
                   JOIN [User] U ON U.Id = GR.CreatedByUserId AND @SprintReplanCount = GR.GoalReplanCount 
				                               AND U.InActiveDateTime IS NULL AND U.IsActive = 1
				   JOIN GoalReplanType GRT ON GRT.Id = GR.GoalReplanTypeId
				                          AND GRT.InActiveDateTime IS NULL AND GRT.CompanyId = @Companyid                                       
				   LEFT JOIN UserStoryReplan USRH ON USRH.GoalReplanId = GR.Id
                   LEFT JOIN UserStory US ON US.Id = USRH.UserStoryId
                   
                   
                   LEFT JOIN TimeZone TZ ON TZ.Id = GR.CreatedDateTimeZone
                   LEFT JOIN UserStoryReplanType USRT ON USRT.Id = USRH.UserStoryReplanTypeId
						                        AND USRT.InActiveDateTime IS NULL --AND USRT.CompanyId = @CompanyId
		           ORDER BY USRH.CreatedDateTime DESC
		END				
		ELSE 
						
			RAISERROR(@HavePermission,11,1)
				
	END TRY
	BEGIN CATCH
			
		THROW
		
	END CATCH
END
GO
