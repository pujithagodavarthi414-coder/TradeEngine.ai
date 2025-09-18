
--EXEC [dbo].[USP_GetStatusConfigurationOptions_New] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE  [dbo].[USP_GetStatusConfigurationOptions_New]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@StatusreportingConfigurationOptionId UNIQUEIDENTIFIER = NULL,
	@OptionName NVARCHAR(250) = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL
)  
AS
BEGIN
    SET NOCOUNT ON

       BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	      DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		  IF(@HavePermission = '1')
		  BEGIN
          
		  IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

           SELECT SRO.Id AS Id,
		          SRO.OptionName,
				  SRO.DisplayName,
				  SRO.SortOrder,
				  SRO.CompanyId,
				  SRO.CreatedDateTime,
				  SRO.CreatedByUserId,
				  SRO.UpdatedDateTime,
				  SRO.UpdatedByUserId,
				  CASE WHEN SRO.[InActiveDateTime] IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
				  SRO.[TimeStamp],
				  TotalCount = COUNT(1) OVER()
        FROM [StatusReportingOption_New] SRO WITH (NOLOCK)
        WHERE  SRO.CompanyId = @CompanyId 
		   AND (@StatusreportingConfigurationOptionId IS NULL OR (SRO.Id = @StatusreportingConfigurationOptionId))
		   AND (@IsArchived IS NULL OR (SRO.[InActiveDateTime] IS NULL AND @IsArchived = 0) OR (SRO.[InActiveDateTime] IS NOT NULL AND @IsArchived = 1))
		   AND (@SearchText IS NULL OR SRO.OptionName LIKE '%' + @SearchText + '%'
		                            OR SRO.DisplayName LIKE '%' + @SearchText + '%')
		ORDER By SRO.SortOrder

		END
		ELSE
		   
		   RAISERROR(@HavePermission,11,1)

    END TRY 
	 
    BEGIN CATCH 
        
        THROW

    END CATCH
END