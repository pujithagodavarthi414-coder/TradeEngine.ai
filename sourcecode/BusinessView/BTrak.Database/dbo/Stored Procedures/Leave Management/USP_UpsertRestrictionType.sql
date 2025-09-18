----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-08-07 00:00:00.000'
-- Purpose      To upsert restriction type by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertRestrictionType]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @RestrictionTypeId = 'FD0158AD-8AD3-4C7D-B992-EF67C9CCF11A', @Restriction = 'test', @IsArchived = 0	
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertRestrictionType]
(
   @RestrictionTypeId UNIQUEIDENTIFIER = NULL,
   @Restriction NVARCHAR(50) = NULL,
   @LeavesCount FLOAT = NULL, 
   @IsWeekly BIT = NULL,
   @IsMonthly BIT = NULL,
   @IsQuarterly BIT = NULL,
   @IsHalfYearly BIT = NULL,
   @IsYearly BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN 
    SET NOCOUNT ON
    BEGIN TRY
	   	   	    
		  IF(@Restriction = '') SET @Restriction = NULL
		  
	      IF(@Restriction IS NULL)
	      
		  BEGIN
		     
		      RAISERROR(50011,16, 2, 'RestrictionType')
		  
		  END
		  ELSE IF (@IsWeekly IS NULL AND @IsMonthly IS NULL AND @IsQuarterly IS NULL AND @IsHalfYearly IS NULL AND @IsYearly IS NULL)
		  BEGIN

			RAISERROR('CheckAnyOfTheOptions',11,1)

		  END
		  ELSE IF (@IsWeekly = 1 AND @LeavesCount > 7)
		  BEGIN

			RAISERROR ('LeavesCountShouldNotBeGreaterthanaWeek',11,1)

		  END
		  ELSE IF (@IsMonthly = 1 AND @LeavesCount > 31)
		  BEGIN

			RAISERROR ('LeavesCountShouldNotBeGreaterthanaMonth',11,1)

		  END
		  ELSE IF (@IsQuarterly = 1 AND @LeavesCount > 123)
		  BEGIN

			RAISERROR ('LeavesCountShouldNotBeGreaterthanaQuarterYear',11,1)

		  END
		  ELSE IF (@IsHalfYearly = 1 AND @LeavesCount > 184)
		  BEGIN

			RAISERROR ('LeavesCountShouldNotBeGreaterthanaHalfYear',11,1)

		  END
		  ELSE IF (@IsYearly = 1 AND @LeavesCount > 366)
		  BEGIN

			RAISERROR ('LeavesCountShouldNotBeGreaterthanaYear',11,1)

		  END
		  ELSE IF ((@IsWeekly IS NOT NULL AND @IsMonthly IS NULL AND @IsQuarterly IS NULL AND @IsHalfYearly IS NULL AND @IsYearly IS NULL) 
		        OR (@IsWeekly IS NULL AND @IsMonthly IS NOT NULL AND @IsQuarterly IS NULL AND @IsHalfYearly IS NULL AND @IsYearly IS NULL) 
				OR (@IsWeekly IS NULL AND @IsMonthly IS NULL AND @IsQuarterly IS NOT NULL AND @IsHalfYearly IS NULL AND @IsYearly IS NULL) 
				OR (@IsWeekly IS NULL AND @IsMonthly IS NULL AND @IsQuarterly IS NULL AND @IsHalfYearly IS NOT NULL AND @IsYearly IS NULL) 
				OR (@IsWeekly IS NULL AND @IsMonthly IS NULL AND @IsQuarterly IS NULL AND @IsHalfYearly IS NULL AND @IsYearly IS NOT NULL))
		  BEGIN
		  		  
                 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				 DECLARE @RestrictionTypeIdCount INT = (SELECT COUNT(1) FROM RestrictionType  WHERE Id = @RestrictionTypeId)
          
				 DECLARE @RestrictionCount INT = (SELECT COUNT(1) FROM RestrictionType WHERE Restriction = @Restriction AND CompanyId = @CompanyId AND (@RestrictionTypeId IS NULL OR Id <> @RestrictionTypeId) AND InActiveDateTime IS NULL)       
       			 
		         DECLARE @LeaveFrequencyCount INT = (SELECT COUNT(1) FROM LeaveFrequency WHERE RestrictionTypeId = @RestrictionTypeId AND InActiveDateTime IS NULL)

				 IF(@RestrictionTypeIdCount = 0 AND @RestrictionTypeId IS NOT NULL)

				 BEGIN
              
		  			RAISERROR(50002,16, 2,'RestrictionType')
          																					
				 END
				 ELSE IF(@RestrictionCount>0)

				 BEGIN
          
					RAISERROR(50001,16,1,'RestrictionType')
             
				 END
				 ELSE IF (@IsArchived = 1 AND @LeaveFrequencyCount > 0)
				 BEGIN

					RAISERROR('RestrictionTypeCantBeArchivedAsThereAreLeaveFrequencies',11,1)

				 END
				 ELSE
				 BEGIN

				 DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

				 IF (@HavePermission = '1')
				 BEGIN
       
						DECLARE @IsLatest BIT = (CASE WHEN @RestrictionTypeId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM RestrictionType WHERE Id = @RestrictionTypeId) = @TimeStamp THEN 1 ELSE 0 END END)
			        
						IF(@IsLatest = 1)
						BEGIN
			      
						DECLARE @Currentdate DATETIME = GETDATE()
			            
						DECLARE @NewRestrictionTypeId UNIQUEIDENTIFIER = NEWID()
                        
						IF (@RestrictionTypeId IS NULL)
						BEGIN
						INSERT INTO [dbo].[RestrictionType](
						            [Id],
			   	         			[Restriction],
									[LeavesCount],
									[IsWeekly],
			   	         			[IsMonthly],
									[IsQuarterly],
									[IsHalfYearly],
									[IsYearly],
									[CompanyId],
									[InActiveDateTime],
									[CreatedByUserId],
									[CreatedDateTime]
			   	         			)
							 SELECT @NewRestrictionTypeId,
			   	         	        @Restriction,
									@LeavesCount,
									ISNULL(@IsWeekly,0),
									ISNULL(@IsMonthly,0),
									ISNULL(@IsQuarterly,0),
									ISNULL(@IsHalfYearly,0),
									ISNULL(@IsYearly,0),
									@CompanyId,
									CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
									@OperationsPerformedBy,
									@Currentdate
						END
						ELSE
						BEGIN

							UPDATE RestrictionType SET [Restriction]       = @Restriction
									                  ,[LeavesCount]	   = @LeavesCount
													  ,[UpdatedDateTime]    = @Currentdate
													  ,[UpdatedByUserId]   = @OperationsPerformedBy
									                  ,[IsWeekly]		   = ISNULL(@IsWeekly,0)
			   	         			                  ,[IsMonthly]		   = ISNULL(@IsMonthly,0)
									                  ,[IsQuarterly]	   = ISNULL(@IsQuarterly,0)
									                  ,[IsHalfYearly]	   = ISNULL(@IsHalfYearly,0)
									                  ,[IsYearly]		   = ISNULL(@IsYearly,0)
									                  ,[InActiveDateTime]  = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
													  WHERE Id = @RestrictionTypeId
						
						END
						SELECT Id FROM [dbo].[RestrictionType] WHERE Id = ISNULL(@RestrictionTypeId,@NewRestrictionTypeId)
			              
						END				
						ELSE
			      
			      			RAISERROR (50008,11, 1)
			      
				END       
      			ELSE
				BEGIN
	    
					RAISERROR (@HavePermission,11, 1)
	    		
				END
			  END
			END
			ELSE

				RAISERROR ('OnlyOneOptionIspermitted',11,1)
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO