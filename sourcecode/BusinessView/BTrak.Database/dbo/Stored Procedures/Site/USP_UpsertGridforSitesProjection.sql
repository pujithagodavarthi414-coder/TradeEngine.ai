CREATE PROCEDURE [dbo].[USP_UpsertGridforSitesProjection]
	@GridForSiteProjectionId UNIQUEIDENTIFIER,
	@SiteId UNIQUEIDENTIFIER,
	@GridId UNIQUEIDENTIFIER,
	@StartDate DATETIME,
	@EndDate DATETIME,
	@IsArchived BIT=NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
    @TimeStamp TIMESTAMP = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	   DECLARE @HavePermission NVARCHAR(250)  = '1'
	   IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	   IF(@GridForSiteProjectionId = '00000000-0000-0000-0000-000000000000') SET @GridForSiteProjectionId = NULL
	   IF (@HavePermission = '1')
        BEGIN
		DECLARE @CompanyId UNIQUEIDENTIFIER =    (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
		   DECLARE @Currentdate DATETIME = GETDATE()
		  DECLARE @IsLatest BIT = (CASE WHEN @GridForSiteProjectionId IS NULL THEN 1 ELSE 
                                 CASE WHEN (SELECT [TimeStamp] FROM [site] WHERE Id = @GridForSiteProjectionId) = @TimeStamp THEN 1 ELSE 0 END END)
		 DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
		IF(@IsLatest=1)
		BEGIN
		   

		   IF(@GridForSiteProjectionId IS NULL)
		    BEGIN
			     
				SET @GridForSiteProjectionId = NEWID()
			  INSERT INTO [GridForSitesProjection](
			                           Id,
			                           CompanyId,
			                           CreatedDateTime,
			                           CreatedByUserId,
									   InActiveDateTime,
									   SiteId,
									   GridId,
									   StartDate,
									   EndDate
									   )
								SELECT @GridForSiteProjectionId,
								       @CompanyId,
									   @CurrentDate,
									   @OperationsPerformedBy,
									   CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
									   @SiteId,
									   @GridId,
									   @StartDate,
									   @EndDate
			END
			ELSE
			 BEGIN
			 UPDATE [GridForSitesProjection]
			SET CompanyId			   = 		 @CompanyId,
			    CreatedDateTime		   = 		 @CurrentDate,
			    CreatedByUserId		   = 		 @OperationsPerformedBy,
				InActiveDateTime	   = 		 CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
				SiteId				   =         @SiteId,
				GridId				   =		@GridId,
				StartDate			   =		@StartDate,
				EndDate					=		@EndDate
			WHERE Id = @GridForSiteProjectionId
			 
			 END
			 SELECT @GridForSiteProjectionId
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