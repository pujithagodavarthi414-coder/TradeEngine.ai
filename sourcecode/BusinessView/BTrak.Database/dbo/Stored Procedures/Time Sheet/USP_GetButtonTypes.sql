-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Get The ButtonTypes By Applyind Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetButtonTypes]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetButtonTypes]
(
	@ButtonTypeId UNIQUEIDENTIFIER = NULL,
	@ButtonTypeName NVARCHAR(250) = NULL,
	@SearchText		NVARCHAR(250)  = NULL,
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@DeviceId NVARCHAR(500)
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 
		 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
              
		IF(@OperationsPerformedBy IS NULL OR @OperationsPerformedBy = '00000000-0000-0000-0000-000000000000')
        BEGIN
        SET @OperationsPerformedBy = (SELECT TOP 1 UserId FROM dbo.Ufn_GetUsersModeType(@DeviceId, NULL, GETUTCDATE()))
        END

          IF (@HavePermission = '1' OR @DeviceId IS NOT NULL)
          BEGIN

			  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			  IF (@ButtonTypeId =  '00000000-0000-0000-0000-000000000000') SET @ButtonTypeId=NULL

			  IF (@ButtonTypeName = '') SET @ButtonTypeName = NULL

			  IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			 IF(@SearchText = '')SET @SearchText = NULL

			 SET @SearchText = '%'+ @SearchText+'%'

			  SELECT [Id] AS ButtonTypeId,
					 [ButtonTypeName],
					 [CompanyId],
					 IsArchived = CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END,
					 [InActiveDateTime],
			         [CreatedDateTime],
			         [CreatedByUserId],
			         [UpdatedByUserId],
			         [UpDatedDatetime],
					 [TimeStamp],
					 [ButtonCode],
					 [ShortName],
					 TotalCount = COUNT(1) OVER()

			  FROM  [dbo].[ButtonType] WITH (NOLOCK)
			  WHERE CompanyId = @CompanyId 
			       AND (@ButtonTypeId  IS NULL OR Id = @ButtonTypeId)
			       AND (@ButtonTypeName  IS NULL OR ButtonTypeName = @ButtonTypeName)
				   AND (@IsArchived IS NULL OR (@IsArchived = 0 AND InActiveDateTime IS NULL) OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL))
				   AND (@SearchText IS NULL OR (ButtonTypeName LIKE @SearchText))

			   ORDER BY ButtonTypeName ASC 	
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