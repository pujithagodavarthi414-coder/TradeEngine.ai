------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-19 00:00:00.000'
-- Purpose      To Get the EmployeeUserstories By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--   EXEC [dbo].[USP_GetEmployeeUserStories_New] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--   @EmployeeId='30F6A3DD-D686-4F55-A3FC-473E5ED76976',@Status=NULL
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeUserStories_New]
(
     @EmployeeId UNIQUEIDENTIFIER,
	 @Status UNIQUEIDENTIFIER ,
	 @StartDate DATETIME = NULL,
	 @EndDate DATETIME = NULL,
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @IsArchived BIT = 0
)
AS 
BEGIN
     SET NOCOUNT ON

     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	DECLARE @StatusName VARCHAR(500)
	
	IF(@Status = '00000000-0000-0000-0000-000000000000')
	BEGIN
		
		SET @StatusName = NULL
	
	END
	ELSE
	BEGIN
		
		SELECT  @StatusName = status FROM UserStoryStatus WITH (NOLOCK) WHERE Id  = @Status 
	
	END
	   
	   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
       IF (@HavePermission = '1')
       BEGIN
           
		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
   
                    SELECT U.Id UserId,
		                   U.FirstName+' '+ISNULL(U.SurName,'') UserName,
		            	   US.Id AS UserStoryId,
		            	   US.UserStoryName,
		            	   USS.[Status],
		            	   US.DeadLineDate,
		            	   US.EstimatedTime,
		            	   US.[TimeStamp],
		            	   CASE WHEN US.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		               	   TotalCount = COUNT(1) OVER()
		            
                    FROM UserStory US WITH (NOLOCK) INNER JOIN Project P ON P.Id = US.ProjectId  
					                                INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id 
	                                                INNER JOIN [User] U WITH (NOLOCK) ON U.Id = US.OwnerUserId 
	                                                INNER JOIN Employee E WITH (NOLOCK) ON E.UserId=U.Id
	                                                LEFT JOIN Goal G WITH (NOLOCK) ON G.Id = US.GoalId 
		            								LEFT JOIN Sprints S WITH (NOLOCK) ON S.Id = US.SprintId 
                    WHERE (G.InActiveDateTime IS NULL AND S.InActiveDateTime IS NULL) AND (US.ArchivedDateTime IS NULL)
                          AND (@StatusName IS NULL OR USS.[Status] = @StatusName)
                          AND (@StartDate IS NULL OR US.DeadLineDate >= CONVERT(DATE,@StartDate)) AND (@EndDate IS NULL OR US.DeadLineDate <= CONVERT(DATE,@EndDate))
	                	  AND U.CompanyId = @CompanyId
	                	  AND E.Id = @EmployeeId
		            	  AND (@IsArchived IS NULL OR (@IsArchived = 0 AND US.InActiveDateTime IS NULL)
		            		  OR (@IsArchived = 1 AND US.InActiveDateTime IS NOT NULL))
		     
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