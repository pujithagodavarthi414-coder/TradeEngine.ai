CREATE PROCEDURE [dbo].[USP_GetClientTypes]
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
           STUFF((SELECT ',' + RoleName
     FROM ClientTypeRoles CTR
      INNER JOIN [Role] R ON R.Id = CTR.RoleId
             AND R.InactiveDateTime IS NULL AND CTR.InactiveDateTime IS NULL
 WHERE CTR.ClientTypeId = C.Id
                          ORDER BY RoleName
FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleNames,
STUFF((SELECT ',' + LOWER(CTR.RoleId)
     FROM ClientTypeRoles CTR
      INNER JOIN [Role] R ON R.Id = CTR.RoleId
             AND R.InactiveDateTime IS NULL AND CTR.InactiveDateTime IS NULL
 WHERE CTR.ClientTypeId = C.Id
                          ORDER BY RoleName
FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleIds,
ROW_NUMBER() OVER ( ORDER BY IIF(C.ClientTypeName ='SUPPLIER',1,IIF(C.ClientTypeName ='Other',3,2))) ,
[TimeStamp],
[Order]
           FROM ClientType AS C
           WHERE C.CompanyId = @CompanyId
           AND (@IsArchived IS NULL OR (@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND C.InActiveDateTime IS NULL))
			ORDER BY [Order]
                
                
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