----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-09-24 00:00:00.000'
-- Purpose      To Get Client History by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetClientHistory] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @ClientHistoryId = '643D0E90-7A1E-4EFA-8B57-2B3FA07455FD'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetClientHistory]
(
  @ClientHistoryId UNIQUEIDENTIFIER = NULL,
  @OldValue NVARCHAR(250) = NULL,
  @NewValue NVARCHAR(250) = NULL,
  @FieldName NVARCHAR(100) = NULL,
  @Description NVARCHAR(800) = NULL,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection VARCHAR(50)= NULL,
  @PageSize INT = NULL,
  @PageNumber INT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY

       DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

       IF (@HavePermission = '1')
       BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   
	       IF(@ClientHistoryId = '00000000-0000-0000-0000-000000000000') SET  @ClientHistoryId = NULL
		   
	       IF(@OldValue = '') SET  @OldValue = NULL

	       IF(@NewValue = '') SET  @NewValue = NULL

	       IF(@FieldName = '') SET  @FieldName = NULL

	       IF(@SortBy IS NULL ) SET  @SortBy = 'CreatedDateTime'

	       IF(@SortDirection IS NULL ) SET  @SortDirection = 'DESC'

	       IF(@PageSize IS NULL ) SET  @PageSize = (SELECT COUNT(1) FROM [dbo].[ClientHistory])

	       IF(@PageNumber IS NULL ) SET  @PageNumber = 1

		   IF(@PageSize = 0)
		   BEGIN
				SELECT @PageSize = 10, @PageNumber = 1
		   END

	       SELECT CH.Id AS ClientHistoryId,
				  CH.ClientId,
				  CH.OldValue,
				  CH.NewValue,
				  CH.FieldName,
				  CH.[Description],
				  CH.CreatedDateTime,
                  CH.CreatedByUserId,
                  CH.[TimeStamp], 
		          TotalCount = COUNT(1) OVER()
		   FROM ClientHistory AS CH WITH (NOLOCK)
				 LEFT JOIN Client C ON C.Id = CH.ClientId
		   WHERE CH.CompanyId = @CompanyId
				 AND (@ClientHistoryId IS NULL OR CH.Id = @ClientHistoryId)
		         AND (@OldValue IS NULL OR CH.OldValue = @OldValue)
		         AND (@NewValue IS NULL OR CH.NewValue = @NewValue)
		         AND (@FieldName IS NULL OR CH.FieldName = @FieldName)
		         AND (@Description IS NULL OR CH.[Description] = @Description)
		   ORDER BY CASE WHEN @SortDirection  = 'ASC' THEN
						 CASE WHEN @SortBy = 'OldValue' THEN CH.OldValue
						      WHEN @SortBy = 'NewValue' THEN CH.NewValue
						      WHEN @SortBy = 'FieldName' THEN CH.FieldName
						      WHEN @SortBy = 'Description' THEN CH.[Description]
						      WHEN @SortBy = 'CreatedDateTime' THEN CONVERT(DATETIME,CH.CreatedDateTime)
						END 
						END ASC,
						CASE WHEN @SortDirection  = 'DESC' THEN
					    CASE WHEN @SortBy = 'OldValue' THEN CH.OldValue
						     WHEN @SortBy = 'NewValue' THEN CH.NewValue
						     WHEN @SortBy = 'FieldName' THEN CH.FieldName
						     WHEN @SortBy = 'Description' THEN CH.[Description]
						     WHEN @SortBy = 'CreatedDateTime' THEN CONVERT(DATETIME,CH.CreatedDateTime)
						END 
					END DESC 
		OFFSET ((@PageNumber - 1) * @PageSize) ROWS

		FETCH NEXT @PageSize ROWS ONLY
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
