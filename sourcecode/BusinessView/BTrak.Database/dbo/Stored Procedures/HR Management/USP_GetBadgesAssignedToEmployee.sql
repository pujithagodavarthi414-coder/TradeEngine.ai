-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-05-15 00:00:00.000'
-- Purpose      To Get Badges assigned to  employee
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetBadgesAssignedToEmployee] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetBadgesAssignedToEmployee]
(
	@UserId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsForOverView BIT
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
 
            IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
			IF(@IsForOverView = '1')
			BEGIN
				SELECT T.BadgeId,
					   T.BadgeName,
					   T.ImageUrl,
					   T.BadgeCount,
					   (SELECT EB.CreatedByUserId AS AssignedById,ABU.FirstName + ' ' + ISNULL(ABU.SurName,'') AS AssignedBy,EB.BadgeDescription FROM EmployeeBadge EB 
					   JOIN [User] ABU ON ABU.Id = EB.CreatedByUserId
					   WHERE EB.BadgeId =  T.BadgeId
					   FOR XML PATH ('BadgeDetailsModel'),ROOT('BadgeModel')
					   ) AS BadgeDetailsXml
					   FROM (
							SELECT B.Id BadgeId
								,B.BadgeName
								,B.ImageUrl
								,COUNT(1) AS BadgeCount
								 FROM EmployeeBadge EB JOIN Badge B ON B.Id = EB.BadgeId AND EB.AssignedTo = @UserId AND EB.InActiveDateTime IS NULL
								 GROUP BY B.Id,B.BadgeName,B.ImageUrl) T
			END
			ELSE 
			BEGIN
					  SELECT  EB.Id,
								  B.Id AS BadgeId,
					            B.BadgeName,
								  B.ImageUrl,
								  B.[Description],
								  EB.BadgeDescription,
								  EB.CreatedByUserId AS AssignedById,
								  EB.AssignedTo AS AssignedToId,
								  U.FirstName + ' ' + ISNULL(U.SurName,'') AS AssignedToUser,
								  UA.ProfileImage AS AssignedByProfileImage,
								  UA.FirstName + ' ' + ISNULL(UA.SurName,'') AS AssignedBy,
								  CASE WHEN EB.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
					            TotalCount = COUNT(1) OVER()
					  FROM EmployeeBadge EB 
							JOIN Badge B ON B.Id = EB.BadgeId AND B.InActiveDateTime IS NULL
						    JOIN [Employee] E ON E.Id = EB.AssignedTo 
						    JOIN [User] U ON U.Id = E.UserId
							JOIN [User] UA ON UA.Id = EB.CreatedByUserId
						WHERE  EB.InActiveDateTime IS NULL
					  	AND (@UserId IS NULL OR EB.AssignedTo = @UserId)
					  ORDER BY EB.CreatedDateTime DESC
			END
 
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
GO
