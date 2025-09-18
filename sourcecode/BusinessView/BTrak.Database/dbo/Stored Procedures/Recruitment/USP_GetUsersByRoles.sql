CREATE PROCEDURE [dbo].[USP_GetUsersByRoles]
(
@OperationsPerformedBy UNIQUEIDENTIFIER,
@RoleIds NVARCHAR(MAX)
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				      
				DECLARE @Temp TABLE
				(Id UNIQUEIDENTIFIER)

					INSERT INTO @Temp(Id)
					SELECT Id FROM dbo.UfnSplit(@RoleIds)
					
					SELECT U.Id AS Id,
					U.ProfileImage,
                        U.FirstName,
                        U.SurName,
                        U.FirstName +' '+ISNULL(U.SurName,'') as FullName
                 FROM  [dbo].[User] U WITH (NOLOCK)
                 JOIN [dbo].[Company] C ON C.Id = U.CompanyId AND C.InactiveDateTime IS NULL
                WHERE  (@RoleIds IS NULL OR U.Id IN (SELECT UserId FROM UserRole UR INNER JOIN @Temp T ON T.Id = UR.RoleId AND UR.InactiveDateTime IS NULL))
                       AND (U.CompanyId = @CompanyId)
					   AND U.InActiveDateTime IS NULL
					         
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

