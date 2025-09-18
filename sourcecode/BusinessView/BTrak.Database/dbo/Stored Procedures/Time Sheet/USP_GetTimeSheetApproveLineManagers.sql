-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTimeSheetApproveLineManagers] @OperationsPerformedBy = '63447806-B0BE-452C-8C38-F3EAD87322B3'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTimeSheetApproveLineManagers]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

         DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
 
            
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
          SELECT U.FirstName+' '+U.SurName UserName,
				 UserId ,
				 U.ProfileImage,
				 U.IsActive
		  FROM RoleFeature RF
				JOIN [UserRole] UR ON UR.RoleId = RF.RoleId AND featureId = '3845D5C9-E786-49E2-8262-5C2E251257EF'
				JOIN [User] U ON U.Id = UR.UserId AND U.CompanyId = @CompanyId
				AND UserId <> @OperationsPerformedBy
         GROUP BY U.FirstName,UserId,U.SurName ,  U.ProfileImage, U.IsActive

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