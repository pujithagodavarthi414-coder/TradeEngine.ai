-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Save or update the ExpenseStatus
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertExpenseStatus] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@Name='Test',@Description='Test'

CREATE PROCEDURE [dbo].[USP_UpsertExpenseStatus]
(
  @ExpenseStatusId UNIQUEIDENTIFIER = NULL,
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

			  DECLARE @IsLatest BIT = (CASE WHEN @ExpenseStatusId IS NULL 
											  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] 
											                         FROM [ExpenseStatus] WHERE Id = @ExpenseStatusId) = @TimeStamp 
															   THEN 1 ELSE 0 END END)
			  IF(@IsLatest = 1)
			  BEGIN

			      DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 

			      DECLARE @Currentdate DATETIME = GETDATE()
		          
				  IF(@ExpenseStatusId IS NULL)
				  BEGIN

				  SET @ExpenseStatusId = NEWID()
				  INSERT INTO [dbo].[ExpenseStatus](
			        		     [Id],
								 [Name],
			        			 [Description],
								 [CreatedByUserId],
								 [CreatedDateTime],
								 [InActiveDateTime])
                    
					SELECT @ExpenseStatusId,
			                     @Name,
								 @Description,
								 @OperationsPerformedBy,
								 @Currentdate ,
								 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
					
					END			 	                    	  		          
					ELSE
					BEGIN

					UPDATE [dbo].[ExpenseStatus]
							 SET [Name]				   =  			 @Name,
			        			 [Description]		   =  			 @Description,
								 [CreatedByUserId]	   =  			 @OperationsPerformedBy,
								 [CreatedDateTime]	   =  			 @Currentdate ,
								 [InActiveDateTime]	   =  			 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
							WHERE Id = @ExpenseStatusId

					END
		          SELECT Id Id FROM [dbo].[ExpenseStatus] WHERE Id = @ExpenseStatusId

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
