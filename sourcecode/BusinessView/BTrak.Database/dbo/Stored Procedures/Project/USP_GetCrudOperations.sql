-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-16 00:00:00.000'
-- Purpose      To Get the CrudOperations By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetCrudOperations] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetCrudOperations]
(
  @CrudOperationId UNIQUEIDENTIFIER = NULL,
  @OperationName  NVARCHAR(100) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
  @IsArchived BIT = NULL
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
     
        IF(@CrudOperationId = '00000000-0000-0000-0000-000000000000') SET @CrudOperationId = NULL;
    
        IF(@OperationName = '') SET @OperationName = NULL
    
        SELECT CO.Id AS CrudOperationId,
               CO.OperationName,
               CO.CompanyId,
               CO.CreatedByUserId,
               CO.CreatedDateTime,
               CO.UpdatedByUserId,
               CO.UpdatedDateTime,
               CO.[TimeStamp],
               CASE WHEN CO.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
               TotalCount = COUNT(1) OVER()
        FROM  [dbo].[CrudOperation] CO WITH (NOLOCK)
        WHERE CO.CompanyId = @CompanyId
              AND (@CrudOperationId IS NULL OR CO.Id = @CrudOperationId)
              AND (@OperationName IS NULL OR CO.OperationName = @OperationName)
              AND (@IsArchived IS NULL OR (CO.InactiveDateTime IS NULL AND @IsArchived = 0) OR (CO.InactiveDateTime IS NOT NULL AND @IsArchived = 1))
     END
     ELSE
       
       RAISERROR(@HavePermission,11,1)
     END TRY  
     BEGIN CATCH 
        
        THROW
    END CATCH
END
