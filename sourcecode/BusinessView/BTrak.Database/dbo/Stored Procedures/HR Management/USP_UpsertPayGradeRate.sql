-------------------------------------------------------------------------------
-- Author       Aswani k
-- Created      '2019-05-07 00:00:00.000'
-- Purpose      To Get the Break Types
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertPayGradeRate]
--@PayGradeId = 'E1ED7877-B1D9-41D3-A575-166F9639FD87',
--@RateIds = N'<?xml version="1.0" encoding="utf-16"?>
--<GenericListOfPayGradeRateModel xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--<ListItems>
--<PayGradeRateModel>
--<PayGradeRateId>D8AA7374-45C2-4D68-AC97-2BEB3F6CAE75</PayGradeRateId>
--<RateId>3E9E9952-DBDD-4E9E-BA03-8EB25CEBC1C7</RateId>
--<TimeStamp>0x0000000000002A61</TimeStamp>
--</PayGradeRateModel>
--<PayGradeRateModel>
--<PayGradeRateId>A41774B8-F94C-4411-9C3B-61365A379848</PayGradeRateId>
--<RateId>458AB78A-B728-41FE-B9BB-3FA1FB16621C</RateId>
--<TimeStamp>0x0000000000002A65</TimeStamp>
--<IsArchived>false</IsArchived>
--</PayGradeRateModel>
--<PayGradeRateModel>
--<PayGradeRateId>F0B149C9-42E6-4926-BCBD-7BBB68CE5DDB</PayGradeRateId>
--<RateId>79C51748-F6A4-4A96-AC80-847F75FAF254</RateId>
--<TimeStamp>0x0000000000002A64</TimeStamp>
--<IsArchived>true</IsArchived>
--</PayGradeRateModel>
--<PayGradeRateModel>
--<PayGradeRateId>2A618845-9F70-4DAD-9AE3-BA247D49FBB9</PayGradeRateId>
--<RateId>0514DFC9-542E-4241-B4EF-7E564AD0D9A7</RateId>
--<TimeStamp>0x0000000000002A62</TimeStamp>
--<IsArchived>true</IsArchived>
--</PayGradeRateModel>
--<PayGradeRateModel>
--<PayGradeRateId>84C558F1-0A40-4C11-ABEB-FD64753E5299</PayGradeRateId>
--<RateId>4ED62B55-31DD-4751-9D7A-EFC386003570</RateId>
--<TimeStamp>0x0000000000002A63</TimeStamp>
--</PayGradeRateModel>
--</ListItems>
--</GenericListOfPayGradeRateModel>',@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPayGradeRate]
(
   @PayGradeId UNIQUEIDENTIFIER = NULL,
   @RateIds XML = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	    
		IF(@PayGradeId = '00000000-0000-0000-0000-000000000000') SET @PayGradeId = NULL

	    DECLARE @TempRate TABLE
        (
            RowNumber INT IDENTITY(1,1),
			PayGradeRateId UNIQUEIDENTIFIER,
            RateId UNIQUEIDENTIFIER,
			[TimeStamp] NVARCHAR(100) NULL,
			IsArchived BIT NULL
        )

	    INSERT INTO @TempRate (PayGradeRateId,RateId,[TimeStamp],IsArchived) 
	    SELECT 
		CASE WHEN [TABLE].RECORD.value('(PayGradeRateId)[1]', 'NVARCHAR(500)') = ' ' THEN NULL ELSE [TABLE].RECORD.value('(PayGradeRateId)[1]', 'NVARCHAR(500)') END,
		CASE WHEN [TABLE].RECORD.value('(RateId)[1]', 'NVARCHAR(500)') = ' ' THEN NULL ELSE [TABLE].RECORD.value('(RateId)[1]', 'NVARCHAR(500)') END,
		CASE WHEN [TABLE].RECORD.value('(TimeStamp)[1]', 'NVARCHAR(100)') = ' ' THEN NULL ELSE [TABLE].RECORD.value('(TimeStamp)[1]', 'NVARCHAR(100)') END,
		[TABLE].RECORD.value('(IsArchived)[1]', 'BIT')
	    FROM @RateIds.nodes('/GenericListOfPayGradeRateModel/ListItems/PayGradeRateModel') AS [TABLE](RECORD)

		DECLARE @RateIdsCount INT =  (SELECT COUNT (1) FROM @TempRate)

	    IF(@PayGradeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'PayGrade')

		END
		ELSE IF(@RateIds IS NULL OR @RateIdsCount = 0)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Rate')

		END
		ELSE
		BEGIN

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
			     DECLARE @PayGradeRateId UNIQUEIDENTIFIER 
			     
			     DECLARE @RateId UNIQUEIDENTIFIER 
			     
			     DECLARE @RateName NVARCHAR(500) 
			     
			     DECLARE @PayGradeName NVARCHAR(500) 
			     
			     DECLARE @TimeStamp NVARCHAR(100)  
			     
			     DECLARE @IsEligible BIT = 0 
			     
			     DECLARE @errorMessage NVARCHAR(1200) = NULL

			     WHILE(@RateIdsCount >= 1)
		         BEGIN
			     
			          SELECT @PayGradeRateId = PayGradeRateId,@RateId = RateId  FROM @TempRate WHERE RowNumber = @RateIdsCount
			     
			     	  DECLARE @PayGradeRateIdCount INT = (SELECT COUNT(1) FROM [dbo].[PayGradeRate] WHERE Id = @PayGradeRateId)
			     
				      SET  @PayGradeName = (SELECT PayGradeName FROM PayGrade WHERE Id = @PayGradeId )

					  SET  @RateName = (SELECT Rate FROM RateType WHERE Id = @RateId)

                      IF(@PayGradeRateIdCount  = 0 AND @PayGradeRateId IS NOT NULL)
				      BEGIN
				      
				          SET @IsEligible  = 0
				      
				   	      SET @errorMessage = 'WithThisPaygradeAndRate'
				      
				          RAISERROR(50002,16, 1, @errorMessage)
				      
				   	      BREAK
				      END
				      ELSE
				      BEGIN
				         
				   	   SET @IsEligible  = 1
				      
				      END

			       SET @RateIdsCount  = @RateIdsCount - 1

		         END

			     SET @RateIdsCount =  (SELECT COUNT (1) FROM @TempRate)
			     
		         WHILE(@RateIdsCount >= 1)
		         BEGIN

			      SELECT @PayGradeRateId = PayGradeRateId , @TimeStamp = [TimeStamp]
				  FROM @TempRate WHERE RowNumber = @RateIdsCount

				  DECLARE @IsLatest BIT = (CASE WHEN @PayGradeRateId IS NULL 
			                              THEN 1 ELSE CASE WHEN CONVERT(NVARCHAR(50), CONVERT(BINARY(8), (SELECT [TimeStamp]
			                                          FROM [dbo].[PayGradeRate] WHERE Id = @PayGradeRateId)), 1)  = @TimeStamp
															THEN 1 ELSE 0 END END)
          
                   IF(@IsLatest  = 1)
				   BEGIN
				   
				       SET @IsEligible = 1
				   
				   END
				   ELSE
				   BEGIN
				      
				       SET @IsEligible  = 0
				   
				       RAISERROR ('ThisPayGradeIsAlreadyUpdatedPleaseRefreshThePageForNewChanges',11, 1)
				     
				       BREAK
				   
				   END

				   SET @RateIdsCount  = @RateIdsCount - 1
		    END

		         IF(@IsEligible = 1)
			     BEGIN
			     
				     DECLARE @Currentdate DATETIME = GETDATE()
			         
			     	      INSERT INTO [dbo].[PayGradeRate](
			                          [Id],
			                          [PayGradeId],
								      [RateId],
								      [InActiveDateTime],
			                          [CreatedDateTime],
			                          [CreatedByUserId]
									  )
			                   SELECT NEWID(),
			                          @PayGradeId,
								      TR.RateId,
								      CASE WHEN TR.IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                          @Currentdate,
			                          @OperationsPerformedBy
								      FROM @TempRate TR WHERE RowNumber = @RateIdsCount AND PayGradeRateId IS NULL

						       UPDATE [dbo].[PayGradeRate]
			                     SET  [PayGradeId] = @PayGradeId,
								      [RateId] = T.RateId,
								      [InActiveDateTime] = CASE WHEN T.IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                          [UpdatedDateTime] = @Currentdate,
			                          [UpdatedByUserId] = @OperationsPerformedBy
									 FROM @TempRate T
									 WHERE T.PayGradeRateId = PayGradeRate.Id
					      
				  END
					     
						 SELECT TOP(1) PayGradeId FROM PayGradeRate WHERE PayGradeId = @PayGradeId
			   
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
GO