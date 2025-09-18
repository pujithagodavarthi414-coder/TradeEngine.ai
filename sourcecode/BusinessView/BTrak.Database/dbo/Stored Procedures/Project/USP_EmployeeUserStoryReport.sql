-------------------------------------------------------------------------------
-- Author      Geetha CH
-- Created     '2019-09-25 00:00:00.000'
-- Purpose      To Get the Employee UserStories By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_EmployeeUserStoryReport] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@DeadLineDateFrom='2020-01-01',@DeadLineDateTo = '2020-01-31',@PageSize=10000
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_EmployeeUserStoryReport]
(
  @DeadLineDateFrom DATETIME,
  @DeadLineDateTo DATETIME,
  @OwnerUserId UNIQUEIDENTIFIER = NULL,
  @ProjectId UNIQUEIDENTIFIER = NULL,
  @UserStoryStatusId UNIQUEIDENTIFIER = NULL,
  @SortDirection NVARCHAR(250) = NULL,
  @SearchText NVARCHAR(250 )= NULL,
  @SortBy NVARCHAR(200) = NULL,
  @PageNumber INT = 1,
  @PageSize INT = 10,
  @EntityId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
		IF(@DeadLineDateFrom IS NULL OR @DeadLineDateTo IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Date')

		END
		ELSE
		BEGIN
		  DECLARE @CompanyId UNIQUEIDENTIFIER =  (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   
		   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN

		    IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
			
			IF(@UserStoryStatusId = '00000000-0000-0000-0000-000000000000')
			BEGIN
				
				SET @UserStoryStatusId = NULL

			END

			IF(@OwnerUserId = '00000000-0000-0000-0000-000000000000')
			BEGIN
				
				SET @OwnerUserId = NULL

			END

				IF(@SortDirection IS NULL )
	            BEGIN

	    	        SET @SortDirection = 'DESC'

	            END

				IF(@SortBy IS NULL )
	            BEGIN

	    	        SET @SortBy = 'UserStoryName'

	            END

				IF(@OwnerUserId IS NOT NULL)
				BEGIN

					DECLARE @TempUserId UNIQUEIDENTIFIER = (SELECT Id FROM [User] WHERE Id = @OwnerUserId)

					IF(@TempUserId IS NULL)
					BEGIN

					DECLARE @TempUserId1 UNIQUEIDENTIFIER = (SELECT Id FROM [Employee] WHERE UserId = @OwnerUserId)

					IF(@TempUserId1 IS NOT NULL) SET @OwnerUserId = @TempUserId1
					IF(@TempUserId1 IS NULL) SET @OwnerUserId = NULL

					END

				END

				SET @SearchText = '%'+ @SearchText +'%'
				
				SELECT EU.OwnerName
				       ,EU.UserStoryName
					   ,EU.EstimatedTime
					   ,EU.DeadLineDate
					   ,EU.UserStoryStatusName
					   ,EU.TimeZoneAbbreviation
					   ,EU.TimeZoneName
					   ,TotalCount = COUNT(1) OVER()
					   ,EU.OwnerUserId
				       FROM
				       (
							SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS OwnerName
							       ,US.UserStoryName
								   ,ISNULL(US.EstimatedTime,0)EstimatedTime
								   ,US.DeadLineDate
								   ,TZ.TimeZoneAbbreviation
								   ,TZ.TimeZoneName
								   ,USS.[Status] AS UserStoryStatusName
								   ,U.Id AS OwnerUserId
								 
							FROM [dbo].[UserStory] US
							     INNER JOIN [dbo].[UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
								             AND ((US.GoalId IS NOT NULL AND US.DeadLineDate IS NOT NULL) OR (US.SprintId IS NOT NULL))
								            AND US.InactiveDateTime IS NULL AND US.ParkedDateTime IS NULL
								            AND USS.InactiveDateTime IS NULL
											AND (US.UserStoryStatusId = @UserStoryStatusId OR @UserStoryStatusId IS NULL)
											AND (US.OwnerUserId = @OwnerUserId OR @OwnerUserId IS NULL)
								LEFT JOIN TimeZone TZ ON TZ.Id = US.DeadLineDateTimeZone AND TZ.InActiveDateTime IS NULL
								 LEFT JOIN Goal G ON G.Id = US.GoalId
								 LEFT JOIN Sprints S ON S.Id = US.SprintId
								 INNER JOIN [User] U ON U.Id = US.OwnerUserId AND U.IsActive = 1
											AND U.CompanyId = @CompanyId
								            AND U.InactiveDateTime IS NULL
								 INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
								 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
											AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
											AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
							WHERE ((US.GoalId IS NOT NULL AND CAST(US.DeadlineDate AS date) >= CAST(@DeadLineDateFrom AS date) AND CAST(US.DeadlineDate AS date)  <= CAST(@DeadLineDateTo AS date))
							OR (CAST(S.SprintEndDate AS DATE) >= CAST(@DeadLineDateFrom AS DATE) AND CAST(S.SprintEndDate AS date) <=  CAST(@DeadLineDateTo AS date)))
							AND (@ProjectId IS NULL OR US.ProjectId = @ProjectId)
						) EU
				        WHERE (@SearchText IS NULL 
								  OR(EU.OwnerName LIKE @SearchText)
				                  OR(EU.UserStoryName LIKE @SearchText)
				                  OR(EU.EstimatedTime LIKE @SearchText)
				                  OR(EU.DeadLineDate LIKE @SearchText)
				                  OR(EU.UserStoryStatusName LIKE @SearchText)
				              )
							  
				         ORDER BY 
							 CASE WHEN (@SortDirection IS NULL OR  @SortDirection = 'DESC') THEN
				                CASE WHEN(@SortBy = 'OwnerName') THEN EU.OwnerName
				                     WHEN @SortBy = 'UserStoryName' THEN EU.UserStoryName
				                     WHEN @SortBy = 'EstimatedTime' THEN CAST(EU.EstimatedTime AS SQL_VARIANT)
				                     WHEN @SortBy = 'DeadLineDate' THEN CAST(EU.DeadLineDate AS SQL_VARIANT)
				                     WHEN @SortBy = 'UserStoryStatusName' THEN EU.UserStoryStatusName
				                END
				           END DESC,
				           CASE WHEN @SortDirection = 'ASC' THEN
				                CASE WHEN(@SortBy = 'OwnerName') THEN EU.OwnerName
				                     WHEN @SortBy = 'UserStoryName' THEN EU.UserStoryName
				                     WHEN @SortBy = 'EstimatedTime' THEN CAST(EU.EstimatedTime AS SQL_VARIANT)
				                     WHEN @SortBy = 'DeadLineDate' THEN CAST(EU.DeadLineDate AS SQL_VARIANT)
				                     WHEN @SortBy = 'UserStoryStatusName' THEN EU.UserStoryStatusName
				                END
				           END ASC
				                                                                                                 
						  OFFSET ((@PageNumber - 1) * @PageSize) ROWS

				          FETCH NEXT @PageSize ROWS ONLY
						         
				END
				ELSE
				RAISERROR (@HavePermission,11, 1)

		END                                                                                                                    
    
     END TRY  
     BEGIN CATCH 
        
           THROW

    END CATCH
END 
GO