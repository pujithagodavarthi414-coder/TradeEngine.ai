-------------------------------------------------------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetApproverUsers] @OperationsPerformedBy = '63447806-B0BE-452C-8C38-F3EAD87322B3'
-------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetApproverUsers]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS 
BEGIN
 SET NOCOUNT ON
    BEGIN TRY
	    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	     IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

         DECLARE @HavePermission NVARCHAR(250)  ='1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN 
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				
			 SELECT UserId, 
				       CONCAT(U.FirstName,' ',ISNULL(U.SurName,'')) UserName ,
					   U.ProfileImage,
					   U.IsActive
		       FROM [TimeSheetPunchCard] TSPC
					  JOIN [Status] S ON S.Id = TSPC.StatusId AND S.StatusName = 'Waiting for Approval'
					  JOIN [User] U ON U.Id = TSPC.UserId 
				 WHERE U.CompanyId = @CompanyId AND S.CompanyId = @CompanyId AND TSPC.ApproverId = @OperationsPerformedBy
				 GROUP BY UserId , U.FirstName , U.SurName , U.ProfileImage , U.IsActive
		
		 END
		 ELSE

			RAISERROR(@HavePermission,11,1)
	 END TRY
    BEGIN CATCH 
        THROW
    END CATCH
END
GO
