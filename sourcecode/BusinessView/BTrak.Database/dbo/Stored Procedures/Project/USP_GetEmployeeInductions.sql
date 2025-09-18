-------------------------------------------------------------------------------
-- Author       Anupam sai kumar vuyyuru
-- Created      '2019-05-24 00:00:00.000'
-- Purpose      To Get The induction work of employee
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployeeInductions] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeInductions]
(
   @UserId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON
		BEGIN TRY
	    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

      IF (@HavePermission = '1')
      BEGIN
      
	      DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
          
		  DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT Id FROM Project WHERE ProjectName = 'Induction Project' AND CompanyId = @CompanyId)
	       
	          SELECT US.UserStoryName AS InductionName
                     ,US.OwnerUserId AS AssignedToId
              	     ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS AssignedToName
              	     ,U.ProfileImage AS AssignedToImage
              	     ,USS.[Status]
              FROM UserStory US
                   INNER JOIN [User] U On U.Id = US.OwnerUserId
              	 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
              WHERE ProjectId = @ProjectId
                    AND (@UserId IS NULL
              	       OR US.UserStoryName LIKE '%(' + (SELECT EmployeeNumber FROM Employee E WHERE E.UserId = @UserId) + ')%'
					   OR US.OwnerUserId = @UserId)					   
		   
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
