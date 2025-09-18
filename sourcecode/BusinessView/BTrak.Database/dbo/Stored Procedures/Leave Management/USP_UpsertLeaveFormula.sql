----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-08-08 00:00:00.000'
-- Purpose      To Upsert Leave Formula by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertLeaveFormula]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @LeaveFormulaId = 'A0FD3FBA-EACF-4C48-87BC-C8546C204348', @Formula = 'test', @IsArchived = 0	
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertLeaveFormula]
(
   @LeaveFormulaId UNIQUEIDENTIFIER = NULL,
   @Formula NVARCHAR(200) = NULL,
   @SalaryTypeId UNIQUEIDENTIFIER = NULL,
   @NoOfDays INT = 0,
   @NoOfLeaves INT = 0,
   @PayRoleId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN 
    SET NOCOUNT ON
    BEGIN TRY
	   	   	    
		  IF(@Formula = '') SET @Formula = NULL  
		  
		  DECLARE @LeaveFrequencyCount INT = (SELECT COUNT(1) FROM LeaveFrequency WHERE LeaveFormulaId = @LeaveFormulaId AND InActiveDateTime IS NULL)

	      IF(@Formula IS NULL)
		  BEGIN
		     
		      RAISERROR(50011,16, 2, 'Formula')
		  
		  END
		  ELSE IF (@NoOfDays = 0)
		  BEGIN

			RAISERROR('NoOfDaysShouldBeGreaterThanZero',11,1)

		  END
		  ELSE IF (@NoOfLeaves = 0)
		  BEGIN

			RAISERROR('NoOfLeavesShouldBeGreaterThanZero',11,1)

		  END
		  ELSE IF (@IsArchived = 1 AND @LeaveFrequencyCount > 0)
		  BEGIN

			RAISERROR('LeaveFormulaCantBeArchivedAsThereAreLeaveFrequencies',11,1)

		  END
		  ELSE 
		  		  
				 DECLARE @LeaveFormulaIdCount INT = (SELECT COUNT(1) FROM LeaveFormula WHERE Id = @LeaveFormulaId)

				 DECLARE @FormulaCount INT = (SELECT COUNT(1) FROM LeaveFormula WHERE Formula = @Formula AND (@LeaveFormulaId IS NULL OR Id <> @LeaveFormulaId) AND CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)))
          				        	  
				 IF(@LeaveFormulaIdCount = 0 AND @LeaveFormulaId IS NOT NULL)

				 BEGIN
              
		  			RAISERROR(50002,16, 2,'LeaveFormula')
          
				 END
				 ELSE IF(@FormulaCount>0)

				 BEGIN
          
					RAISERROR(50001,16,1,'Formula')
             
				 END
				 ELSE

				 DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

				 IF (@HavePermission = '1')
				 BEGIN
       
						DECLARE @IsLatest BIT = (CASE WHEN @LeaveFormulaId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM LeaveFormula WHERE Id = @LeaveFormulaId) = @TimeStamp THEN 1 ELSE 0 END END)
			        
						IF(@IsLatest = 1)
						BEGIN
			      									      
						DECLARE @Currentdate DATETIME = GETDATE()
			            
						DECLARE @NewLeaveFormulaId UNIQUEIDENTIFIER = NEWID()
						
						IF (@LeaveFormulaId IS NULL)
						BEGIN

						INSERT INTO [dbo].[LeaveFormula](
						            [Id],
									[Formula],
									[SalaryTypeId],
									[NoOfDays],
									[NoOfLeaves],					
									[CompanyId],
									[InactiveDateTime],
									[PayroleId],
									[CreatedDateTime],
									[CreatedByUserId]
			   	         			)
							 SELECT @NewLeaveFormulaId,
									@Formula,
									@SalaryTypeId,
									@NoOfDays,
									@NoOfLeaves,
									[dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy),
									CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
									@PayRoleId,
									GETDATE(),
									@OperationsPerformedBy

						END
						ELSE
						BEGIN

							UPDATE LeaveFormula SET [Formula]         =  @Formula
									               ,[SalaryTypeId]	  =  @SalaryTypeId
									               ,[NoOfDays]		  =  @NoOfDays
									               ,[NoOfLeaves]	  =  @NoOfLeaves
												   ,[UpdatedDateTime] =  @Currentdate
												   ,[UpdatedByUserId] =  @OperationsPerformedBy
												   ,[InactiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
												   WHERE Id = @LeaveFormulaId

						END
						
						SELECT Id FROM [dbo].[LeaveFormula] WHERE Id = ISNULL(@LeaveFormulaId,@NewLeaveFormulaId)
									              
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
        
        THROW

    END CATCH
END
GO