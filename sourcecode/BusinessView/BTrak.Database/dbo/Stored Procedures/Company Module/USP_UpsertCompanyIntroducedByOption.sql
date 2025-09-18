-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-05-22 00:00:00.000'
-- Purpose      To Save or update the Company Introduced By option
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertCompanyIntroducedByOption] @Option = 'Test',@IsArchived = 1,@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@IntroducedByOptionId='B2F0A12D-CA5F-409F-AB7C-49C941BDBA03', @TimeStamp= 0x0000000000003FD4

CREATE PROCEDURE [dbo].[USP_UpsertCompanyIntroducedByOption]
(
 @IntroducedByOptionId UNIQUEIDENTIFIER = NULL,
 @Option NVARCHAR(250) = NULL,
 @IsArchived BIT = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

   SET NOCOUNT ON
   
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

   IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
   
   IF (@IntroducedByOptionId = '00000000-0000-0000-0000-000000000000') SET @IntroducedByOptionId = NULL
   
   IF (@Option = '') SET @Option = NULL
   
   IF (@OPTION IS NULL)
   BEGIN

    RAISERROR(500011,16,2,'Option')

   END
   ELSE
      
   BEGIN
      
	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	
	IF(@HavePermission = '1')
	BEGIN
	 
	   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	   
	   DECLARE @IntroducedByOptionCount INT = (SELECT COUNT(1) FROM [CompanyIntroducedByOption] 
											   WHERE (Id = @IntroducedByOptionId AND CompanyId = @CompanyId )) 

	   DECLARE @OptionIdCount INT = (SELECT COUNT(1) FROM [CompanyIntroducedByOption]
	                                 WHERE   CompanyId = @CompanyId and ([Option] = @Option AND 
									 (@IntroducedByOptionId IS NULL OR Id <> @IntroducedByOptionId ) 
									  ))

                IF (@IntroducedByOptionCount = 0 AND @IntroducedByOptionId IS NOT NULL)
	            BEGIN
	               
	               RAISERROR(50002,16,1,'CompanyIntroducedByOption')
	            
	            END
	            
	            ELSE IF(@OptionIdCount > 0)
	            BEGIN
	              
	            RAISERROR(50001,16,1,'CompanyIntroducedByOption')
	            
	            END
	            ELSE
	            BEGIN
	             
	               DECLARE @IsLatest INT = (CASE WHEN @IntroducedByOptionId IS NULL THEN 1 
	                                             ELSE CASE WHEN (SELECT [TimeStamp] FROM [dbo].[CompanyIntroducedByOption] 
	            								 WHERE (Id = @IntroducedByOptionId AND CompanyId=@CompanyId )) = @TimeStamp THEN 1
	            								 ELSE 0 END END )
                IF(@IsLatest = 1)
	            BEGIN
	             
	              DECLARE @CurrentDate DATETIME = GETDATE()
	            
                IF(@IntroducedByOptionId IS NULL)
				BEGIN

				   SET @IntroducedByOptionId = NEWID()

	              INSERT INTO [dbo].[CompanyIntroducedByOption] (
	                          ID,
	            			  [Option],
	            			  CompanyId,
	            			  InActiveDateTime,
	                          CreatedDateTime,
	                          CreatedByUserId
	            			  )
	            	   SELECT @IntroducedByOptionId,
	            	          @Option,
	            			  @CompanyId,
	            			  CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
	            			  @CurrentDate,
	            			  @OperationsPerformedBy
	            			 
				  END
				  ELSE
				  BEGIN

				  UPDATE [CompanyIntroducedByOption]
				     SET [Option] = @Option,
					     [CompanyId] = @CompanyId,
						 [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
						 [UpdatedDateTime] =@CurrentDate,
						 [UpdatedByUserId] = @OperationsPerformedBy
						 WHERE Id = @IntroducedByOptionId AND CompanyId = @CompanyId

				  END
	            
	            	   SELECT Id FROM [dbo].[CompanyIntroducedByOption] WHERE ID = @IntroducedByOptionId
	             
	            END
	            ELSE 
	               RAISERROR(50008,11,1)
	            
	            END
	 
	END
	 ELSE 
	   
	   RAISERROR(@HavePermission,11,1)

	END

	END TRY
  BEGIN CATCH

     THROW

  END CATCH
 END
 GO