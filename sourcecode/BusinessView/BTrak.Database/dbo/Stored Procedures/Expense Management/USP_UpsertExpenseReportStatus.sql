-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Save or update the ExpenseReportStatus
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertExpenseReportStatus] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@Name='Test',@Description='Test'

CREATE PROCEDURE [dbo].[USP_UpsertExpenseReportStatus]
(
  @ExpenseReportStatusId UNIQUEIDENTIFIER = NULL,
  @Description NVARCHAR (800),
  @Name        NVARCHAR(250)=NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeStamp TIMESTAMP = NULL
)
AS 
BEGIN    
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 

			  DECLARE @IsLatest BIT = (CASE WHEN @ExpenseReportStatusId IS NULL 
											  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] 
											                         FROM [ExpenseReportStatus] WHERE Id = @ExpenseReportStatusId) = @TimeStamp 
															   THEN 1 ELSE 0 END END)

			  IF(@IsLatest = 1)
			  BEGIN

			      DECLARE @Currentdate DATETIME = GETDATE()
			      
				  IF(@ExpenseReportStatusId IS NULL)
				  BEGIN

				  SET @ExpenseReportStatusId = NEWID()
		          INSERT INTO [dbo].[ExpenseReportStatus](
			        		     [Id],
								 [Name],
			        			 [Description],
								 [CompanyId],			        			        			 
								 [CreatedByUserId],
								 [CreatedDateTime],
								 [InActiveDateTime])
                          
						  SELECT @ExpenseReportStatusId,
			                     @Name,
								 @Description,
								 @CompanyId,
								 @OperationsPerformedBy,
								 @Currentdate ,
								 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
								
					END
					ELSE
					BEGIN

					UPDATE [dbo].[ExpenseReportStatus]
							 SET [Name]						=  		@Name,
			        			 [Description]				=  		@Description,
								 [CompanyId]			    =      	@CompanyId,		        			 
								 [UpdatedByUserId]			=  		@OperationsPerformedBy,
								 [UpdatedDateTime]			=  		@Currentdate ,
								 [InActiveDateTime]			=  		CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
								 WHERE Id = @ExpenseReportStatusId

					END

		          SELECT Id FROM [dbo].[ExpenseReportStatus] WHERE Id = @ExpenseReportStatusId

			  END
			  ELSE
			  BEGIN

			      RAISERROR (50008,11, 1)

			  END

	END TRY  
	BEGIN CATCH 
		
		  EXEC USP_GetErrorInformation

	END CATCH

END
