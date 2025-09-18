-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetConductUserDropDown] @OperationsPerformedBy = 'B03D90CC-586A-4837-9B63-8EBF4BE7BBF7'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetConductUserDropDown]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
     @isBranchFilter BIT = NULL
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
       
          
        IF(@isBranchFilter = 1)
        BEGIN
                SELECT U.FirstName+' '+U.SurName UserName,
				 U.Id UserId ,
				 U.ProfileImage,
				 U.IsActive
         FROM [User] U
				INNER JOIN Employee E ON E.UserId = U.Id AND U.IsActive = 1
				INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id 
	                  AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
        WHERE U.CompanyId = @CompanyId
               AND U.InactiveDateTime IS NULL
	           AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
				GROUP BY U.FirstName,U.Id,U.SurName ,U.ProfileImage, U.IsActive
         END
         ELSE
         BEGIN
           SELECT U.FirstName + ' ' + U.SurName UserName,
				 U.Id UserId ,
				 U.ProfileImage,
				 U.IsActive
		  FROM AuditConduct AC
				JOIN [User] U ON U.Id = AC.CreatedByUserId AND U.CompanyId = @CompanyId
          WHERE AC.ProjectId IN (SELECT UP.ProjectId FROM [Userproject] UP 
                                 WHERE UP.InactiveDateTime IS NULL 
                                       AND UP.UserId = @OperationsPerformedBy)
         GROUP BY U.FirstName,U.Id,U.SurName ,  U.ProfileImage, U.IsActive

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