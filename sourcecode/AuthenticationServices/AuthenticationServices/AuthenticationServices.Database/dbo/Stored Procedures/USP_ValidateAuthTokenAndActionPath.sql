-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ValidateAuthTokenAndActionPath]
(
     @UserId UNIQUEIDENTIFIER,
     @CompanyId UNIQUEIDENTIFIER,
     @ActionPath NVARCHAR(800) = NULL,
	 @AuthToken NVARCHAR(MAX) = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
        IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

        DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @UserId AND UR.CompanyId =  @CompanyId AND R.CompanyId = @CompanyId),0)

        IF(EXISTS(SELECT UserId FROM UserAuthToken UAT WHERE UAT.CompanyId = @CompanyId AND UAT.UserId = @UserId AND AuthToken = @AuthToken))
		BEGIN
            
            DECLARE @output BIT = 0
            DECLARE @AccessAll BIT
    
	        SELECT @AccessAll =1
            --CASE WHEN EXISTS (SELECT 1 FROM [dbo].[ControllerApiName] RA
            --WHERE RA.ActionPath = @ActionPath AND RA.AccessAll = 1) THEN 1 ELSE 0 END

            IF(@AccessAll = 1)
            BEGIN
                SET @output = 1
            END
            ELSE
            BEGIN
                SELECT @output = CASE WHEN EXISTS(SELECT 1 
	                                            FROM [dbo].[ControllerApiName] CAN 
	       										 INNER JOIN [dbo].[ControllerApiFeature] CAF ON CAF.[ControllerApiNameId] = CAN.Id AND CAN.[ActionPath] = @ActionPath
	       										 INNER JOIN [dbo].[Feature] F ON CAF.FeatureId = F.Id
	       										 INNER JOIN [dbo].[RoleFeature] RF ON RF.FeatureId = F.Id AND RF.RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@UserId, @CompanyId))
	       		                         ) THEN 1 ELSE 0 END
            END

            IF(@output = 1)
		    BEGIN
                
                SELECT U.Id,
                  U.FirstName,
                  U.SurName,
                  U.UserName AS Email,
                  U.FirstName +' '+ ISNULL(U.SurName,'') as FullName,
                  U.IsAdmin,
                  U.ProfileImage,
				  UC.CompanyId
               FROM  [dbo].[User] U WITH (NOLOCK)
               INNER JOIN UserCompany AS UC ON UC.UserId = U.Id
		       WHERE U.Id = @UserId AND UC.UserId = @UserId
		             AND UC.CompanyId = @CompanyId
				     AND ((U.InActiveDateTime IS NULL
				     AND U.IsActive = 1) OR @IsSupport = 1)

            END
            ELSE
		        RAISERROR('UnAuthorized',11,1)

        END
        ELSE
		    RAISERROR('UnAuthorized',11,1)

    END TRY
    BEGIN CATCH
        
        THROW
 
    END CATCH 
 END
GO