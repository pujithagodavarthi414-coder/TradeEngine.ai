-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-01-31 00:00:00.000'
-- Purpose      To Save or Update the TransitionDeadline
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTransitionDeadline] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@DeadLine='2019-03-20'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTransitionDeadline]
(
   @TransitionDeadlineId UNIQUEIDENTIFIER = NULL,
   @DeadLine NVARCHAR(800) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @TimeStamp TIMESTAMP = NULL,
   @IsArchived BIT = NULL
)
AS
BEGIN
       SET NOCOUNT ON
	   BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	           IF(@IsArchived = 1 AND @TransitionDeadlineId IS NOT NULL)
		       BEGIN
		        
		          DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
    	        
                  --IF(EXISTS(SELECT TransitionDeadlineId FROM [WorkflowEligibleStatusTransition] WHERE TransitionDeadlineId = @TransitionDeadlineId))
                  --BEGIN
	              
                  --SET @IsEligibleToArchive = 'ThisTransitionDeadLineUsedInWorkFlowEligibleStatusTransitionDeleteTheDependenciesAndTryAgain'
                  
                  --END
		        
			      IF(@IsEligibleToArchive <> '1')
                  BEGIN
                
                   RAISERROR (@isEligibleToArchive,11, 1)
                
                   END
		        END

	            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @TransitionDeadlineIdCount INT = (SELECT COUNT(1) FROM TransitionDeadline WHERE Id = @TransitionDeadlineId AND CompanyId = @CompanyId)

				DECLARE @DeadLineCount INT = (SELECT COUNT(1) FROM TransitionDeadline WHERE Deadline = @DeadLine AND CompanyId = @CompanyId)

				DECLARE @UpdateDeadLineCount INT = (SELECT COUNT(1) FROM TransitionDeadline WHERE Deadline = @DeadLine AND CompanyId = @CompanyId AND Id <> @TransitionDeadlineId)


			    IF(@TransitionDeadlineIdCount = 0 AND @TransitionDeadlineId IS NOT NULL)
			    BEGIN
			    		
						RAISERROR(50002,16, 1,'TransitionDeadline')

			    END

				ELSE IF(@DeadLineCount > 0 AND @TransitionDeadlineId IS NULL)
				BEGIN
				
						RAISERROR(50001,16,1,'TransitionDeadline')
				
				END

				ELSE IF(@UpdateDeadLineCount > 0 AND @TransitionDeadlineId IS NOT NULL)
				BEGIN
				
						RAISERROR(50001,16,1,'TransitionDeadline')
				
				END
			    
			    ELSE
			    BEGIN

			     	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
                    IF (@HavePermission = '1')
                    BEGIN

					DECLARE @IsLatest BIT = (CASE WHEN @TransitionDeadlineId IS NULL THEN 1 ELSE 
		                         CASE WHEN (SELECT [TimeStamp] FROM TransitionDeadline WHERE Id = @TransitionDeadlineId) = @TimeStamp THEN 1 ELSE 0 END END )
								 
	                IF (@IsLatest = 1)
		            BEGIN

					   DECLARE @Currentdate DATETIME = GETDATE()
					   
	                   IF(@TransitionDeadlineId IS NULL)
					   BEGIN

					   SET @TransitionDeadlineId = NEWID()

					                  INSERT INTO [dbo].[TransitionDeadline](
			  		                              [Id],
			  				                      [Deadline],
			  				                      [CompanyId],
			  				                      [CreatedDateTime],
			  				                      [CreatedByUserId],
								                  [InActiveDateTime]							 
							                     )
					                      SELECT  @TransitionDeadlineId,
			  			                          @DeadLine,
			  			 	                      @CompanyId,
			  			 	                      @Currentdate,
			  			 	                      @OperationsPerformedBy,
						             		      CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

					  END
					  ELSE
					  BEGIN

					 UPDATE  [dbo].[TransitionDeadline]
			  		  SET    [Deadline] = @DeadLine,
			  				 [CompanyId] = @CompanyId,
			  				 [UpdatedDateTime] = @Currentdate,
			  				 [UpdatedByUserId] = @OperationsPerformedBy,
							 [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
							 WHERE Id = @TransitionDeadlineId

					  END

			           SELECT Id FROM [dbo].[TransitionDeadline] where Id = @TransitionDeadlineId

		            END
		            ELSE
		                
		  	           RAISERROR(50008,11,1)
		            END
		            ELSE
                    BEGIN
                            
		              RAISERROR (@HavePermission,11, 1)
                               
                    END 
			END
		END TRY  
	    BEGIN CATCH 
		
		   THROW

	   END CATCH

END
