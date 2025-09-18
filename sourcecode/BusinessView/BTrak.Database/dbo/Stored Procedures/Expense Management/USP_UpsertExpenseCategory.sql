-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-18 00:00:00.000'
-- Purpose      To Save or Update Expense Category
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_UpsertExpenseCategory] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ExpenseCategoryName='New Branch Started'

CREATE PROCEDURE [dbo].[USP_UpsertExpenseCategory]
(
  @ExpenseCategoryId UNIQUEIDENTIFIER = NULL,
  @ExpenseCategoryName NVARCHAR(200) = NULL,
  @Description NVARCHAR(500) = NULL,
  @IsSubCategory BIT = NULL,
  @AccountCode NVARCHAR(250) = NULL,
  @ImageUrl NVARCHAR(250) = NULL,
  @IsActive BIT = NULL,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
) 
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

				DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				IF(@HavePermission = '1')			 
				BEGIN
	
				DECLARE @IsLatest BIT = (CASE WHEN @ExpenseCategoryId IS NULL 
											  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] 
											                         FROM [ExpenseCategory] WHERE Id = @ExpenseCategoryId) = @TimeStamp 
															   THEN 1 ELSE 0 END END)

				IF(@IsLatest = 1)
				BEGIN
				
					DECLARE @Currentdate DATETIME = GETDATE()

					SET @ExpenseCategoryName = LTRIM(RTRIM(@ExpenseCategoryName))

					IF(@ExpenseCategoryName = '') SET @ExpenseCategoryName  = NULL

					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
					
					DECLARE @ExpenseCategoryIdCount INT = (SELECT COUNT(1) FROM ExpenseCategory WHERE Id = @ExpenseCategoryId)

					DECLARE @ExpenseCategoryNameCount INT = (SELECT COUNT(1) FROM ExpenseCategory WHERE [CategoryName] = @ExpenseCategoryName AND CompanyId = @CompanyId AND (@ExpenseCategoryId IS NULL OR Id <> @ExpenseCategoryId))
					
					IF(@ExpenseCategoryIdCount = 0 AND @ExpenseCategoryId IS NOT NULL)
					BEGIN
					    RAISERROR(50002,16, 2,'ExpenseCategory')
					END
					ELSE IF(@ExpenseCategoryNameCount > 0)
					BEGIN
					  RAISERROR(50001,16,1,'ExpenseCategory')
					 END
					 ELSE IF(@ExpenseCategoryName IS NULL)
					BEGIN
					  RAISERROR(50011,16,1,'ExpenseCategory')
					 END
					 ELSE
						BEGIN
							IF(@ExpenseCategoryId IS NULL)
								BEGIN

									SET @ExpenseCategoryId = NEWID()
				    				INSERT INTO [dbo].[ExpenseCategory](
				    	            Id,
				    	            CategoryName,
				    				IsSubCategory,
				    				AccountCode,
				    				[Image],
				    				[Description],
				    	            CompanyId,
				    	            CreatedDateTime,
				    	            CreatedByUserId,
									InActiveDateTime)
				    	     SELECT @ExpenseCategoryId,
				    	            @ExpenseCategoryName,
				    				@IsSubCategory,
				    				@AccountCode,
				    				@ImageUrl,
				    				@Description,
				    	            @CompanyId,
				    	            @Currentdate,
				    	            @OperationsPerformedBy,
									CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
				    
								END
							ELSE
								BEGIN

									UPDATE [dbo].[ExpenseCategory]
												SET CategoryName			=	 @ExpenseCategoryName,
													IsSubCategory			=	 @IsSubCategory,
													AccountCode				=	 @AccountCode,
													[Image]					=	 @ImageUrl,
													[Description]			=	 @Description,
										            CompanyId				=	 @CompanyId,
										            CreatedDateTime			=	 @Currentdate,
										            CreatedByUserId			=	 @OperationsPerformedBy,
													InActiveDateTime		=	 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
													WHERE Id = @ExpenseCategoryId

								END
							SELECT Id FROM [dbo].[ExpenseCategory] WHERE Id = @ExpenseCategoryId
						END
				END
				ELSE
					RAISERROR (50008,11, 1)

				END
				ELSE
				BEGIN
				
					RAISERROR (@HavePermission,11, 1)
						
				END

	END TRY
	BEGIN CATCH

	    	EXEC [dbo].[USP_GetErrorInformation]

	END CATCH

END
GO