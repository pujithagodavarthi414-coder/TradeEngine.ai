CREATE PROCEDURE [dbo].[USP_GetClientTypesBasedOnRoles]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @ClientId UNIQUEIDENTIFIER = NULL,
    @SearchText NVARCHAR(250) = NULL,
    @PageSize INT = 10,
    @PageNumber INT = 1,
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50) = NULL,
    @IsArchived BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN
           IF(@SearchText = '') SET @SearchText = NULL
           SET @SearchText = '%'+ @SearchText +'%';              
           IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'
                   
           IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'
           
           IF(@IsArchived IS NULL) SET @IsArchived = 0
           IF(@ClientId = '00000000-0000-0000-0000-000000000000') SET @ClientId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
           
          
           SELECT C.Id AS ClientTypeId,C.ClientTypeName,
C.[TimeStamp],
[Order]
           FROM ClientType AS C
           INNER JOIN ClientTypeRoles AS CTR ON CTR.ClientTypeId=C.Id 
           AND CTR.RoleId IN (SELECT RoleId FROM [UserRole] WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL)
           WHERE C.CompanyId = @CompanyId
           AND CTR.InactiveDateTime IS NULL
           AND C.InActiveDateTime IS NULL
		   GROUP BY C.Id,C.ClientTypeName,C.[TimeStamp],C.[Order]
			ORDER BY [Order] ASC
                
                
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