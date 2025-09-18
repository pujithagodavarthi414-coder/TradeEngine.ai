-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2020-02-01 00:00:00.000'
-- Purpose      To Insert Form History
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_GetFormHistory] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@GenericFormSubmittedId = '56A3B20D-96B8-473C-9698-60E306608C7D'
 
 CREATE PROCEDURE [dbo].[USP_GetFormHistory]
(
  @GenericFormSubmittedId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @SortDirection NVARCHAR(10) = NULL,
  @SortBy NVARCHAR(150) = NULL,
  @PageSize INT = NULL,
  @PageNumber INT = NULL
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
           IF(@GenericFormSubmittedId = '00000000-0000-0000-0000-000000000000') SET  @GenericFormSubmittedId = NULL
           
		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDate'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

           IF(@PageSize IS NULL) SET @PageSize = 50
           
           IF(@PageNumber IS NULL) SET @PageNumber = 1
           SELECT FH.Id AS FormHistoryId,
                  FH.GenericFormSubmittedId,
                  FH.FieldName,
                  FH.OldFieldValue,
                  FH.NewFieldValue,
                  GF.FormName,
                  GF.FormJson,
                  CU.Id AS CreatedByUserId,
                  CU.FirstName + ' ' + ISNULL(CU.SurName,'') AS CreatedBy,
                  CU.ProfileImage AS CreatedProfileImage,
                  FH.CreatedDateTime,
                  CONVERT(NVARCHAR(100),FH.CreatedDateTime) AS CreatedDate,
                  FH.[TimeStamp],   
                  TotalCount = COUNT(1) OVER()
           FROM  [dbo].[FormHistory] FH
                 INNER JOIN [User] CU ON CU.Id = FH.CreatedByUserId
                            AND CU.CompanyId = @CompanyId
                 LEFT JOIN GenericFormSubmitted GFS ON GFS.Id = FH.GenericFormSubmittedId
                 LEFT JOIN GenericForm GF ON GF.Id = GFS.FormId
          WHERE (@GenericFormSubmittedId IS NULL OR FH.GenericFormSubmittedId = @GenericFormSubmittedId)
          ORDER BY 
		  CASE WHEN @SortDirection = 'ASC'
		        THEN CASE WHEN @SortBy = 'FieldName' THEN FH.FieldName
				          WHEN @SortBy = 'NewFieldValue' THEN CAST(FH.NewFieldValue AS NVARCHAR(100))
				          WHEN @SortBy = 'CreatedBy' THEN CU.FirstName + ' ' + ISNULL(CU.SurName,'')
				          WHEN @SortBy = 'CreatedDate' THEN CAST(FH.CreatedDateTime AS SQL_VARIANT)
				END 
		  END ASC,
		  CASE WHEN @SortDirection = 'DESC'
		        THEN CASE WHEN @SortBy = 'FieldName' THEN FH.FieldName
				          WHEN @SortBy = 'NewFieldValue' THEN CAST(FH.NewFieldValue AS NVARCHAR(100))
				          WHEN @SortBy = 'CreatedBy' THEN CU.FirstName + ' ' + ISNULL(CU.SurName,'')
				          WHEN @SortBy = 'CreatedDate' THEN CAST(FH.CreatedDateTime AS SQL_VARIANT)
				END 
		  END DESC

          OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
          FETCH NEXT @pageSize ROWS ONLY

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