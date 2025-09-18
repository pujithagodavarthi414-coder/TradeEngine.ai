--EXEC USP_GetGoalReplanHistory @GoalId = 'e2cbfb3f-20f0-4614-b797-cca841998cfb', @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@GoalReplanCount = 6
CREATE PROCEDURE [dbo].[USP_GetGoalReplanHistory]
(
@GoalId UNIQUEIDENTIFIER,
@GoalReplanCount INT = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER
)
As
BEGIN 
	SET NOCOUNT ON 
	BEGIN 	TRY
				
        DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM Goal WHERE Id = @GoalId)

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
				
		IF (@HavePermission='1')
		BEGIN 
						
			DECLARE @CompanyId UNIQUEIDENTIFIER=(SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @MaxReplanCount INT = (SELECT COUNT(1)FROM GoalReplan WHERE GoalId = @GoalId)

			IF (@GoalReplanCount IS NULL) SET @GoalReplanCount = @MaxReplanCount

			DECLARE @ApprovedUserId UNIQUEIDENTIFIER,@GoalCreatedDateTime DATETIMEOFFSET 
			
			SELECT TOP 1 @ApprovedUserId = CreatedByUserId,
			             @GoalCreatedDateTime = CreatedDateTime 
			             FROM Goal 
						 WHERE UpdatedDateTime > (SELECT CreatedDateTime
											             FROM GoalReplan 
														 WHERE GoalId = @GoalId 
														   AND GoalReplanCount = @GoalReplanCount ) 
						ORDER BY CreatedDateTime

			DECLARE @ApprovedUser NVARCHAR(100) =  (SELECT Firstname + ' ' + ISNULL(Surname,'') 
			                                               FROM [User] WHERE Id = @ApprovedUserId)
            DECLARE @GoalDelay INT = (SELECT DATEDIFF(DAY,MAX(ActualDeadLineDate),MAX(DeadLineDate)) FROM UserStory WHERE GoalId = @GoalId AND CreatedDateTime <= @GoalCreatedDateTime GROUP BY GoalId)

            SELECT GR.CreatedDateTime AS DateOfReplan,
			       GR.Id AS GoalReplanId,
                   G.Id As GoalId,
			       G.GoalName,
				   TZ.TimeZoneAbbreviation,
				   TZ.TimeZoneName,
			       USRH.GoalReplanCount,
				   @MaxReplanCount AS MaxReplanCount,
				   @ApprovedUserId AS ApprovedUserId,
				   @ApprovedUser AS ApprovedUser,
                   GRT.GoalReplanTypeName AS GoalReplanName,
			       US.Id AS UserStoryId,
			       US.UserStoryName,
			       US.UserStoryUniqueName,
			       GR.CreatedByUserId,
			       U.FirstName + ' ' + ISNULL(U.SurName,'') AS RequestedBy,
                   USRH.NewValue,
			       USRH.OldValue,
				   USRT.ReplanTypeName AS UserStoryReplanName,
				   CASE WHEN USRT.IsDeadLineChange = 1 THEN ISNULL(DATEDIFF(DAY,US.ActualDeadLineDate,CONVERT(DATE,USRH.[NewValue],103)),0) 
				               ELSE ISNULL(DATEDIFF(DAY,CONVERT(DATE,US.ActualDeadLineDate),US.DeadLineDate),0) END AS [UserStoryDelay],
				   USRH.UserStoryReplanJson AS [Description],
				   ISNULL(@GoalDelay,0) AS GoalDelay,
				   GoalMembers = (STUFF((SELECT ','+CAST(UR.FirstName+' '+ISNULL(UR.SurName,'') AS VARCHAR)
				                         FROM UserStory US 
									     JOIN Goal G ON US.GoalId = G.Id
										  AND US.InactiveDateTime IS NULL
										  AND US.ParkedDateTime IS NULL 
										  AND G.Id = @GoalId 
										 JOIN [User] UR ON UR.Id = US.OwnerUserId AND UR.IsActive = 1
										 GROUP BY CAST(UR.FirstName+' '+ISNULL(UR.SurName,'') AS VARCHAR)
									     FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
                   FROM GoalReplan GR
                   JOIN Goal G ON G.Id = GR.GoalId AND G.InActiveDateTime IS NULL AND G.Id = @GoalId
                   JOIN [User] U ON U.Id = GR.CreatedByUserId AND @GoalReplanCount = GR.GoalReplanCount 
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